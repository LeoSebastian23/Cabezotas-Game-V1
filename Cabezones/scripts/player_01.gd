extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 980.0

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
	
	# Patear
	if Input.is_action_just_pressed("kick") and ball:
		var dir = (ball.global_position - global_position).normalized()
		ball.kick(dir)
	
	# Animaciones
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "quiet"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "quick"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

# Detectar pelota
func _on_Area2D_body_entered(body):
	if body.is_in_group("ball"):
		ball = body

func _on_Area2D_body_exited(body):
	if body == ball:
		ball = null
		
func _on_Area2d_body_entered(body):
	if body.is_in_group("ball"):
		ball = body

func _on_Area2d_body_exited(body):
	if body == ball:
		ball = null


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
