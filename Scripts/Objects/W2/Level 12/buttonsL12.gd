extends HBoxContainer

func _on_back_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 13/Level13.tscn")
