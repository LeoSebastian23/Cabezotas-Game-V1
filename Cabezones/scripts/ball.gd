extends RigidBody2D

@export var kick_force = 600.0

func kick(direction: Vector2):
	# Aplica un impulso en la dirección indicada
	apply_impulse(direction.normalized() * kick_force)
