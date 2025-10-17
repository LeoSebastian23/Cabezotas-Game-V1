extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var jump_force: float = -300.0
@export var gravity: float = 1000.0

@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"
@export var kick_action: String = "kick"

@export var push_force: float = 1.5        # fuerza con el cuerpo
@export var kick_power: float = 1200.0     # fuerza de la patada
@export var kick_cooldown: float = 0.25
@export var start_facing_right: bool = true  # Player1 = true, Player2 = false

@onready var kick_area: Area2D = $KickArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _can_kick: bool = true
var facing_right: bool = true   # orientación fija

func _ready() -> void:
	# Configurar orientación inicial
	facing_right = start_facing_right
	sprite.flip_h = not facing_right   # si mira a la izquierda, flip_h = true

func _physics_process(delta: float) -> void:
	# --- Gravedad y salto ---
	if not is_on_floor():
		velocity.y += gravity * delta
	elif Input.is_action_just_pressed(jump_action):
		velocity.y = jump_force

	# --- Movimiento horizontal (sin cambiar orientación) ---
	velocity.x = 0
	if Input.is_action_pressed(move_left_action):
		velocity.x = -speed
	elif Input.is_action_pressed(move_right_action):
		velocity.x = speed

	# --- Movimiento con físicas ---
	move_and_slide()

	# --- Empuje corporal contra la pelota ---
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision and collision.get_collider() is RigidBody2D:
			var ball := collision.get_collider() as RigidBody2D
			if not ball.has_meta("recently_kicked"):
				var dir := (ball.global_position - global_position).normalized()
				ball.apply_impulse(dir * velocity.length() * push_force)

	# --- Patear ---
	if Input.is_action_just_pressed(kick_action) and _can_kick:
		_perform_kick()


func _perform_kick() -> void:
	_can_kick = false
	
	# Reproducir animación
	if sprite:
		sprite.play("kick")
	
	# Dirección de la patada (según orientación fija)
	var kick_direction := _calculate_kick_direction()
	
	# Ejecutar patada inmediatamente
	if kick_area:
		kick_area.kick(kick_direction, kick_power)
	
	# Cooldown
	await get_tree().create_timer(kick_cooldown).timeout
	_can_kick = true


func _calculate_kick_direction() -> Vector2:
	var dir_x := 1 if facing_right else -1   # derecha o izquierda fijo
	var dir_y := -0.3                        # un poquito hacia arriba (0 = recto)
	return Vector2(dir_x, dir_y).normalized()
