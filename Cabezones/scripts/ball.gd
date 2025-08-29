extends RigidBody2D

@export var kick_force = 400.0

func kick(direction: Vector2):
	# Aplica una fuerza instantánea
	apply_impulse(Vector2.ZERO, direction.normalized() * kick_force)
