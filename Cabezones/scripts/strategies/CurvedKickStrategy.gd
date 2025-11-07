class_name CurvedKickStrategy
extends NormalKickStrategy

func apply_force(ball: RigidBody2D, direction: Vector2, power: float) -> void:
	var curve := Vector2(direction.x, direction.y - 0.4)
	ball.apply_central_impulse(curve.normalized() * power)
