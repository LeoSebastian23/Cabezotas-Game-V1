extends RigidBody2D
class_name Ball

@export var kickable_group: String = "kickable"

var _teleport_to: Vector2 = Vector2.INF

func _ready() -> void:
	if not is_in_group(kickable_group):
		add_to_group(kickable_group)

func teleport(pos: Vector2) -> void:
	_teleport_to = pos
	sleeping = true   # pausa la física hasta que reubiquemos

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _teleport_to != Vector2.INF:
		var xf := state.transform
		xf.origin = _teleport_to
		state.transform = xf
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		_teleport_to = Vector2.INF
		sleeping = false
