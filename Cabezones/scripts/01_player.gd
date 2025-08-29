extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 1200.0
@export var kick_force = 800.0

@onready var anim = $AnimatedSprite2D
@onready var kick_area = $KickArea

var can_jump = true
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	kick_area.monitoring = false  # desactivada por defecto

func _physics_process(_delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * _delta
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

	# Detectar input para patear
	if Input.is_action_just_pressed("kick"):
		anim.play("kick")
		kick_area.monitoring = true  # activar área de patada

	# Mover el personaje
	move_and_slide()

	# Mantener dentro de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)

# Señal del KickArea
func _on_KickArea_body_entered(body):
	if body is RigidBody2D and body.is_in_group("ball"):
		var direction: Vector2 = (body.global_position - global_position).normalized()
		body.linear_velocity = direction * kick_force





	


	
	
