extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 1200.0

var screen_size
var can_jump = true

func _ready():
	screen_size = get_viewport_rect().size
	# Forzar que siempre mire a la izquierda
	$Sprite2D.flip_h = true

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
	
	# Movimiento horizontal
	var horizontal_input = 0
	if Input.is_action_pressed("p2move_right"):
		horizontal_input = 1
	if Input.is_action_pressed("p2move_left"):
		horizontal_input = -1
	
	velocity.x = horizontal_input * speed
	
	# 🔴 Quitamos el cambio de flip dinámico
	# Siempre fijar a la izquierda
	$Sprite2D.flip_h = true
	
	# Salto
	if Input.is_action_just_pressed("p2move_up") and can_jump:
		velocity.y = jump_force
		can_jump = false
	
	move_and_slide()
	
	# Mantener en pantalla
	position = position.clamp(Vector2.ZERO, screen_size)
