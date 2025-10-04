extends Control



func _on_bt_normal_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/levels/levelNormal.tscn")


func _on_bt_apocalipsis_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/levels/levelApocalipsis.tscn")


func _on_bt_neon_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/levels/level_01.tscn")


func _on_bt_atardecer_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/levels/levelAtardecer.tscn")


func _on_bt_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Cabezones/scenes/menus/opciones.tscn")
