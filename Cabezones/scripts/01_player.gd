extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 1200.0

var screen_size
var can_jump = true
var ball = null   # referencia a la pelota

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
	
	# Movimiento horizontal
	var horizontal_input = 0
	if Input.is_action_pressed("move_right"):
		horizontal_input = 1
	if Input.is_action_pressed("move_left"):
		horizontal_input = -1
	
	velocity.x = horizontal_input * speed
	
	# Salto
	if Input.is_action_just_pressed("move_up") and can_jump:
		velocity.y = jump_force
		can_jump = false
	
	move_and_slide()
	
	# Mantener dentro de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
