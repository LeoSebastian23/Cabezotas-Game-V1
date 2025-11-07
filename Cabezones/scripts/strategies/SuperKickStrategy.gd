class_name SuperKickStrategy
extends NormalKickStrategy

func apply_force(ball: RigidBody2D, direction: Vector2, power: float) -> void:
	var boost := 2.5
	ball.apply_central_impulse(direction.normalized() * power * boost)
	ball.angular_velocity = randf_range(-8, 8)  # da efecto de rotación
