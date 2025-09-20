extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400
@export var gravity = 1200

@export var move_left_action: String = "move_left"
@export var move_right_action: String = "move_right"
@export var jump_action: String = "move_up"
@export var kick_action: String = "kick"
@export var kick_power: float = 900.0
@export var kick_duration: float = 0.08
@export var kick_cooldown: float = 0.25

var _facing := 1
var _can_kick := true

@onready var kick_area: Node = $KickArea
var _kick_offset_x := 0.0

func _ready():
	if is_instance_valid(kick_area):
		_kick_offset_x = kick_area.position.x
	else:
		print("ERROR -> KickArea no encontrado en $KickArea")

func _physics_process(delta):
	# gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# movimiento horizontal
	var input_direction = 0
	if Input.is_action_pressed(move_left_action):
		input_direction -= 1
	if Input.is_action_pressed(move_right_action):
		input_direction += 1

	if input_direction != 0:
		_facing = input_direction
		kick_area.position.x = abs(_kick_offset_x) * _facing

	velocity.x = input_direction * speed

	# salto
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_force

	# patear fuerte con tecla
	if Input.is_action_just_pressed(kick_action) and _can_kick:
		_do_kick()

	move_and_slide()

func _do_kick():
	_can_kick = false
	var dir: Vector2 = Vector2(_facing, -0.15).normalized()
	if kick_area.has_method("start_kick"):
		kick_area.start_kick(dir, kick_power, kick_duration)
	_start_kick_cooldown()

func _start_kick_cooldown() -> void:
	await get_tree().create_timer(kick_cooldown).timeout
	_can_kick = true
