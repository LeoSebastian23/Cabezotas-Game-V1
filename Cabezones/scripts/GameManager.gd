extends Node
class_name GameManager

# Arrastrá los nodos desde el inspector
@export var goal_left_path: NodePath
@export var goal_right_path: NodePath
@export var score_ui_path: NodePath
@export var ball_path: NodePath
@export var player1_path: NodePath
@export var player2_path: NodePath

# Variables que guardan las referencias
@onready var goal_left: Goal = get_node_or_null(goal_left_path)
@onready var goal_right: Goal = get_node_or_null(goal_right_path)
@onready var score_ui: ScoreUI = get_node_or_null(score_ui_path)
@onready var ball: RigidBody2D = get_node_or_null(ball_path)
@onready var player1: CharacterBody2D = get_node_or_null(player1_path)
@onready var player2: CharacterBody2D = get_node_or_null(player2_path)

# Scores
var score_p1: int = 0
var score_p2: int = 0

# Posiciones iniciales
var ball_start_pos: Vector2
var player1_start_pos: Vector2
var player2_start_pos: Vector2

# Cronómetro
@export var match_time_sec: int = 30  # duración total del partido en segundos
var time_left: int
var timer: Timer

func _ready() -> void:
	print("✅ GameManager listo. Path actual:", get_path())

	if goal_left:
		goal_left.goal_scored.connect(_on_goal_scored)
	if goal_right:
		goal_right.goal_scored.connect(_on_goal_scored)

	if score_ui:
		score_ui.set_scores(score_p1, score_p2)

	# Guardar posiciones iniciales
	if ball:
		ball_start_pos = ball.global_position
	if player1:
		player1_start_pos = player1.global_position
	if player2:
		player2_start_pos = player2.global_position

	# Inicializar cronómetro
	time_left = match_time_sec
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_tick)
	timer.start()

	if score_ui:
		score_ui.set_time(time_left)


func _on_goal_scored(side_scored_for: StringName) -> void:
	if side_scored_for == &"left":
		score_p1 += 1
	else:
		score_p2 += 1

	if score_ui:
		score_ui.set_scores(score_p1, score_p2)

	_reset_positions()


func _reset_positions() -> void:
	print("♻️ Reseteando posiciones…")

	# --- Pelota ---
	if ball and ball.has_method("teleport"):
		ball.teleport(ball_start_pos)

	# --- Jugadores ---
	if player1:
		player1.velocity = Vector2.ZERO
		player1.call_deferred("set_global_position", player1_start_pos)

	if player2:
		player2.velocity = Vector2.ZERO
		player2.call_deferred("set_global_position", player2_start_pos)

	# Delay antes de reanudar
	await get_tree().create_timer(0.8).timeout

	if ball:
		ball.apply_impulse(Vector2(randf_range(-1, 1), -0.2).normalized() * 200)


func _on_timer_tick() -> void:
	time_left -= 1
	if score_ui:
		score_ui.set_time(time_left)

	if time_left <= 0:
		_end_match()


func _end_match() -> void:
	timer.stop()
	print("🏁 ¡Fin del partido!")
	if score_ui:
		score_ui.show_winner(score_p1, score_p2)
	get_tree().paused = true
