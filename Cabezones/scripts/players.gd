extends CharacterBody2D

# Variables de movimiento
@export var speed = 300
@export var jump_force = -400
@export var gravity = 1200

# Variables para configurar controles
@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"

func _ready():
	print("READY ejecutado")

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	# Movimiento horizontal
	var input_direction = 0
	if Input.is_action_pressed(move_left_action):
		input_direction -= 1
	if Input.is_action_pressed(move_right_action):
		input_direction += 1

	velocity.x = input_direction * speed

	# Salto
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_force

	# Mover el personaje
	move_and_slide()

	

	







	


	
	
