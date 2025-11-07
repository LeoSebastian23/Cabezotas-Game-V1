class_name ScoreUI
extends CanvasLayer

@onready var label_azul: Label = $LabelScoreAzul
@onready var label_rojo: Label = $LabelScoreRojo
@onready var label_timer: Label = $LabelTimer  
@onready var label_winner: Label = $LabelWinner
@onready var button_back: Button = $ButtonBackToMenu

var score_azul: int = 0
var score_rojo: int = 0

func _ready() -> void:
	# Estado inicial limpio y claro
	label_winner.visible = false
	button_back.visible = false
	_update_timer(0)

	# Conectar botón (solo si existe)
	if button_back:
		button_back.pressed.connect(_on_button_back_to_menu_pressed)

# === Actualizar marcador ===
func set_scores(azul: int, rojo: int) -> void:
	score_azul = azul
	score_rojo = rojo
	_update_labels()

func _update_labels() -> void:
	label_azul.text = str(score_azul)
	label_rojo.text = str(score_rojo)
	print("🔄 Actualizando marcador: Azul=%d | Rojo=%d" % [score_azul, score_rojo])

# === Actualizar tiempo del partido ===
func set_time(time_left: int) -> void:
	_update_timer(time_left)

func _update_timer(time_left: int) -> void:
	var minutes := int(time_left / 60)
	var seconds := int(time_left % 60)
	label_timer.text = "%02d:%02d" % [minutes, seconds]

# === Mostrar ganador ===
func show_winner(score_p1: int, score_p2: int) -> void:
	label_winner.text = (
		"🏆 ¡Gana TEAM AZUL!" if score_p1 > score_p2
		else "🏆 ¡Gana TEAM ROJO!" if score_p2 > score_p1
		else "🤝 ¡Empate!"
	)
	label_winner.visible = true
	button_back.visible = true

# === Botón para volver al menú ===
func _on_button_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Cabezones/scenes/menus/seleccion_escenario.tscn")
