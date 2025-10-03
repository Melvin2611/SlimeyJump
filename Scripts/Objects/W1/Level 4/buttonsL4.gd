extends HBoxContainer

@export var current_level_index: int = 3

func _ready():
	ProgressManager.complete_level(current_level_index)

func _on_back_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 5/Level5.tscn")
