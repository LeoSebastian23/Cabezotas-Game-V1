extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 980.0

var screen_size
var can_jump = true
var ball = null

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
	
	var horizontal_input = 0
	if Input.is_action_pressed("p2move_right"):
		horizontal_input = 1
	if Input.is_action_pressed("p2move_left"):
		horizontal_input = -1
	
	velocity.x = horizontal_input * speed
	
	if Input.is_action_just_pressed("p2move_up") and can_jump:
		velocity.y = jump_force
		can_jump = false
	
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Patear
	if Input.is_action_just_pressed("p2kick") and ball:
		var dir = (ball.global_position - global_position).normalized()
		ball.kick(dir)
	
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

func _on_Area2D_body_entered(body):
	if body.is_in_group("ball"):
		ball = body

func _on_Area2D_body_exited(body):
	if body == ball:
		ball = null
