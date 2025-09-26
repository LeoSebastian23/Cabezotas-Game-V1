# Player.gd (modifica tu código existente)
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -300.0
@export var gravity: float = 1000.0

@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"
@export var kick_action: String = "kick"

@export var push_force: float = 1.5        # fuerza con el cuerpo
@export var kick_power: float = 1200.0     # fuerza de la patada
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

# Ejemplo de modificación en la función de empuje corporal (_physics_process)
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision and collision.get_collider() is RigidBody2D:
			var ball := collision.get_collider() as RigidBody2D
			# Verificar que la pelota no acaba de ser pateada
			if not ball.has_meta("recently_kicked"):
				var dir := (ball.global_position - global_position).normalized()
				ball.apply_impulse(dir * velocity.length() * push_force)

	# --- Patear (VERSIÓN MEJORADA) ---
	if Input.is_action_just_pressed(kick_action) and _can_kick:
		_perform_kick()

func _perform_kick() -> void:
	_can_kick = false
	
	# Dirección de patada mejorada
	var kick_direction := _calculate_kick_direction()
	
	# Ejecutar patada inmediatamente
	kick_area.kick(kick_direction, kick_power)
	
	# Cooldown
	await get_tree().create_timer(kick_cooldown).timeout
	_can_kick = true

func _calculate_kick_direction() -> Vector2:
	var base_direction := Vector2.ZERO
	
	# Dirección horizontal según movimiento y mirada del personaje
	if velocity.x != 0:
		base_direction.x = sign(velocity.x)
	else:
		# Si está quieto, usar la escala para determinar dirección
		base_direction.x = 1 if scale.x > 0 else -1
	
	# Componente vertical (hacia arriba)
	base_direction.y = -0.4  # Ajusta este valor para controlar la altura
	
	return base_direction.normalized()
