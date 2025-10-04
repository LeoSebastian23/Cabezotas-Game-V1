class_name ScoreUI
extends CanvasLayer

@onready var label_azul: Label = $LabelScoreAzul
@onready var label_rojo: Label = $LabelScoreRojo
@onready var label_timer: Label = $LabelTimer        # 👉 nuevo Label en la escena
@onready var label_winner: Label = $LabelWinner      # 👉 opcional, para mostrar quién ganó

var score_azul: int = 0
var score_rojo: int = 0

# === Marcador de goles ===
func set_scores(azul: int, rojo: int) -> void:
	score_azul = azul
	score_rojo = rojo
	_update_labels()

func add_goal(for_team: String) -> void:
	if for_team == "azul":
		score_azul += 1
	elif for_team == "rojo":
		score_rojo += 1
	_update_labels()

func reset_scores() -> void:
	score_azul = 0
	score_rojo = 0
	_update_labels()

func _update_labels() -> void:
	print("🔄 Actualizando marcador: Azul=", score_azul, " Rojo=", score_rojo)
	label_azul.text = str(score_azul)
	label_rojo.text = str(score_rojo)


# === Cronómetro ===
func set_time(time_left: int) -> void:
	var minutes = int(time_left / 60)
	var seconds = int(time_left % 60)
	label_timer.text = "%02d:%02d" % [minutes, seconds]


# === Fin de partido ===
func show_winner(score_p1: int, score_p2: int) -> void:
	if score_p1 > score_p2:
		label_winner.text = "🏆 ¡Gana TEAM AZUL!"
	elif score_p2 > score_p1:
		label_winner.text = "🏆 ¡Gana TEAM ROJO!"
	else:
		label_winner.text = "🤝 ¡Empate!"
	label_winner.visible = true
