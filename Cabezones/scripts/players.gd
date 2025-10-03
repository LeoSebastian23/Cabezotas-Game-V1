extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -300.0
@export var gravity: float = 1000.0

@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"
@export var kick_action: String = "kick"

@export var push_force: float = 0.5        # fuerza con el cuerpo (reducida)
@export var kick_power: float = 600.0     # fuerza de la patada (reducida)
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

	# --- EMPUJE MEJORADO ---
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision and collision.get_collider() is RigidBody2D:
			var ball := collision.get_collider() as RigidBody2D
			# Verificar que sea realmente una pelota y no otro objeto
			if ball.is_in_group("ball") and not ball.has_meta("recently_kicked"):
				_apply_push_force(ball)

	# --- Patear ---
	if Input.is_action_just_pressed(kick_action) and _can_kick:
		_perform_kick()

func _apply_push_force(ball: RigidBody2D) -> void:
	# 1. Determinar dirección horizontal basada en la mirada del jugador
	var push_direction := Vector2.RIGHT
	if scale.x < 0:  # Si el sprite está volteado a la izquierda
		push_direction = Vector2.LEFT
	
	# 2. Calcular fuerza base (si está quieto, usar fuerza mínima)
	var horizontal_velocity = velocity.x
	if abs(horizontal_velocity) < 50:  # Si se mueve muy lento o está quieto
		horizontal_velocity = 50 * sign(push_direction.x)  # Fuerza mínima en lugar de velocidad máxima
	
	# 3. Reducir la fuerza base y aplicar límite máximo
	var force_strength = abs(horizontal_velocity) * push_force * 0.1  # Multiplicador adicional
	force_strength = min(force_strength, 100)  # Límite máximo de fuerza
	
	# 4. Aplicar el impulso (principalmente horizontal)
	var force_vector = push_direction * force_strength
	ball.apply_impulse(force_vector)

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
	
	# Componente vertical (ligeramente hacia arriba)
	base_direction.y = -0.4
	
	return base_direction.normalized()
