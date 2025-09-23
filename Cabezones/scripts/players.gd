extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -200.0
@export var gravity: float = 900.0

@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"
@export var kick_action: String = "kick"

@export var push_force: float = 2.0        # fuerza con el cuerpo
@export var kick_power: float = 1200.0     # fuerza de la patada
@export var kick_duration: float = 0.08
@export var kick_cooldown: float = 0.25

@onready var kick_area: Area2D = $KickArea

var _can_kick: bool = true

func _physics_process(delta: float) -> void:
	# --- Gravedad ---
	if not is_on_floor():
		velocity.y += gravity * delta
	elif Input.is_action_just_pressed(jump_action):
		velocity.y = jump_force

	# --- Movimiento horizontal ---
	velocity.x = 0
	if Input.is_action_pressed(move_left_action):
		velocity.x = -speed
	if Input.is_action_pressed(move_right_action):
		velocity.x = speed

	# --- Movimiento con físicas ---
	move_and_slide()

	# --- Empuje con el cuerpo ---
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision and collision.get_collider() is RigidBody2D:
			var ball := collision.get_collider() as RigidBody2D
			var dir := (ball.global_position - global_position).normalized()
			ball.apply_impulse(dir * velocity.length() * push_force)

	# --- Patear ---
	if Input.is_action_just_pressed(kick_action) and _can_kick:
		_start_kick()

func _start_kick() -> void:
	_can_kick = false
	var dir := Vector2(sign(velocity.x), -0.3).normalized()
	kick_area.start_kick(dir, kick_power, kick_duration)
	await get_tree().create_timer(kick_cooldown).timeout
	_can_kick = true
