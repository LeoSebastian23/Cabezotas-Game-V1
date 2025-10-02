class_name ScoreUI
extends CanvasLayer

@onready var label_azul: Label = $LabelScoreAzul
@onready var label_rojo: Label = $LabelScoreRojo

var score_azul: int = 0
var score_rojo: int = 0

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
	
