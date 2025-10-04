extends Node
class_name GameTimer

signal time_updated(time_left: int)
signal match_finished

@export var match_time_sec: int = 60  # duración en segundos
var time_left: int
var timer: Timer

func _ready() -> void:
	time_left = match_time_sec

	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)

	timer.timeout.connect(_on_timer_tick)
	timer.start()

	# Emitir estado inicial
	time_updated.emit(time_left)

func _on_timer_tick() -> void:
	time_left -= 1
	time_updated.emit(time_left)

	if time_left <= 0:
		timer.stop()
		match_finished.emit()
