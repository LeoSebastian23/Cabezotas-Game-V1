class_name ScoreUI
extends CanvasLayer

@onready var label_azul: Label = $LabelScoreAzul
@onready var label_rojo: Label = $LabelScoreRojo
@onready var label_timer: Label = $LabelTimer  # 👈 Añadido
@onready var label_winner: Label = $LabelWinner
@onready var button_back: Button = $ButtonBackToMenu

var score_azul: int = 0
var score_rojo: int = 0

func _ready() -> void:
	# 🔹 Asegurar que todos los elementos inicien visibles correctamente
	if label_winner:
		label_winner.visible = false
	if button_back:
		button_back.visible = false
	if label_timer:
		label_timer.text = "00:00"

func set_scores(azul: int, rojo: int) -> void:
	score_azul = azul
	score_rojo = rojo
	_update_labels()

func _update_labels() -> void:
	if label_azul: label_azul.text = str(score_azul)
	if label_rojo: label_rojo.text = str(score_rojo)
	print("🔄 Actualizando marcador: Azul=%d Rojo=%d" % [score_azul, score_rojo])

# === Mostrar tiempo del partido ===
func set_time(time_left: int) -> void:
	if label_timer == null:
		return

	var minutes := int(time_left / 60)
	var seconds := int(time_left % 60)
	label_timer.text = "%02d:%02d" % [minutes, seconds]

# === Mostrar ganador ===
func show_winner(score_p1: int, score_p2: int) -> void:
	if score_p1 > score_p2:
		label_winner.text = "🏆 ¡Gana TEAM AZUL!"
	elif score_p2 > score_p1:
		label_winner.text = "🏆 ¡Gana TEAM ROJO!"
	else:
		label_winner.text = "🤝 ¡Empate!"

	label_winner.visible = true
	if button_back:
		button_back.visible = true
