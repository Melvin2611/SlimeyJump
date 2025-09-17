extends Control

@export var level_scenes: Array[PackedScene]  # Array mit 18 Level-Szenen (ziehe sie im Inspector rein)

func _ready():
	# Verbinde alle Buttons dynamisch (angenommen, sie heißen Button1 bis Button18)
	for i in range(1, 19):
		var button = get_node("HBoxContainer/VBoxContainer/GridContainer/Button" + str(i))
		button.connect("pressed", func(): _on_level_pressed(i-1))  # i-1 für Array-Index 0-17

func _on_level_pressed(level_index: int):
	if level_index < level_scenes.size() and level_scenes[level_index] != null:
		get_tree().change_scene_to_packed(level_scenes[level_index])  # Lädt das Level
	else:
		print("Level nicht verfügbar")  # Oder zeige eine Nachricht


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")


func _on_button_1_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 1/Level1.tscn")


func _on_button_2_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 2/Level2.tscn")


func _on_button_3_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 3/Level3.tscn")


func _on_button_4_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 4/Level4.tscn")


func _on_button_5_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 5/level5.tscn")


func _on_button_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 6/level6.tscn")


func _on_button_7_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 7/Level7.tscn")


func _on_button_8_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 8/level8.tscn")


func _on_button_9_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 9/Level9.tscn")


func _on_button_10_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 10/Level10.tscn")


func _on_button_11_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 11/level11.tscn")


func _on_button_12_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 12/Level12.tscn")


func _on_button_13_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 13/level13.tscn")


func _on_button_14_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 14/Level14.tscn")


func _on_button_15_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 15/Level15.tscn")


func _on_button_16_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 16/Level16.tscn")


func _on_button_17_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 17/level17.tscn")


func _on_button_18_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 18/Level18.tscn")
