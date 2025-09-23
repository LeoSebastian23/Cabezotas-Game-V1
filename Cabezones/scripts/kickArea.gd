extends Area2D

@export var kickable_group: String = "kickable"

var _active := false
var _dir := Vector2.RIGHT
var _power := 600.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	monitoring = true

func start_kick(direction: Vector2, power: float, duration: float) -> void:
	_dir = direction.normalized()
	_power = power
	_active = true

	# Chequeo inmediato
	for body in get_overlapping_bodies():
		if body is RigidBody2D and body.is_in_group(kickable_group):
			body.apply_central_impulse(_dir * _power)

	await get_tree().create_timer(duration).timeout
	_active = false

func _on_body_entered(body: Node) -> void:
	if _active and body is RigidBody2D and body.is_in_group(kickable_group):
		body.apply_central_impulse(_dir * _power)
