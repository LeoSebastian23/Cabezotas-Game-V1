# KickArea.gd
extends Area2D

@export var kickable_group: String = "kickable"

func kick(direction: Vector2, power: float) -> void:
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body is RigidBody2D and body.is_in_group(kickable_group):
			# Aplicar impulso más consistente
			body.apply_central_impulse(direction.normalized() * power)
			
			# Opcional: agregar efecto visual/sonoro
			_on_kick_success(body)

func _on_kick_success(_ball: RigidBody2D) -> void:
	print("¡Pelota pateada!")
