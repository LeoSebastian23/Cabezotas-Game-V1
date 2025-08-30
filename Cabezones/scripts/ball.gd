extends RigidBody2D

@export var kick_force = 400.0

# Opcional: para resetear el balón
var initial_position: Vector2

func _ready():
	initial_position = global_position
	add_to_group("ball")

func reset_ball():
	global_position = initial_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
