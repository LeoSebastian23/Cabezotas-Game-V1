extends Control

func _ready():
	MusicManager.play("menu")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/menus/seleccion_escenario.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/menus/opciones.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
