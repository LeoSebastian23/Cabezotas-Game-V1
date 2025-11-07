extends Resource
class_name NormalKickStrategy

func apply_kick(ball: RigidBody2D, direction: Vector2, power: float) -> void:
	if not ball:
		return
	ball.apply_central_impulse(direction.normalized() * power)
	print("Normal Kick ejecutado")
