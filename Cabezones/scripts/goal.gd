class_name Goal
extends Node2D

signal goal_scored(side_scored_for: StringName) # Emitido cuando entra la pelota

enum Side { LEFT, RIGHT } # Enum para identificar arco izquierdo o derecho

@export var goal_side: Goal.Side = Goal.Side.LEFT # Qué arco es este
@export var kickable_group: StringName = &"kickable" # Grupo válido para detectar la pelota
@export_range(0.1, 2.0, 0.05) var score_cooldown_s: float = 0.6 # Tiempo mínimo entre goles

@onready var goal_line: Area2D = $GoalLine # Área que detecta entrada de la pelota

var _last_score_time: float = -99.0 # Tiempo del último gol
var _last_body_id: int = -1         # ID del último cuerpo que anotó

func _ready() -> void:
	# Conexión: cuando algo entra al área de gol
	goal_line.body_entered.connect(_on_goal_line_body_entered)

func _on_goal_line_body_entered(body: Node) -> void:
	# Validación: solo cuenta si es pelota (RigidBody2D en grupo correcto)
	if not (body is RigidBody2D): return
	if not body.is_in_group(kickable_group): return

	# Evitar doble conteo del mismo cuerpo en poco tiempo
	var now := Time.get_ticks_msec() / 1000.0
	var id := body.get_instance_id()
	if now - _last_score_time < score_cooldown_s and id == _last_body_id:
		return
	_last_score_time = now
	_last_body_id = id

	# Determinar quién suma punto (según el arco)
	var arco_txt := "IZQUIERDO" if goal_side == Goal.Side.LEFT else "DERECHO"
	var scored_for: StringName = &"right" if goal_side == Goal.Side.LEFT else &"left"

	# Resultado: mostrar gol y emitir señal
	print("⚽ GOL en arco %s → punto para %s" % [arco_txt, String(scored_for).to_upper()])
	goal_scored.emit(scored_for)
