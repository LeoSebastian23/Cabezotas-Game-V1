extends RigidBody2D

@export var kick_force = 400.0

func _ready():
	add_to_group("ball")
