extends Control

func _on_play_pressed():
	$ButtonSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/LevelSelect.tscn")  # Wechselt zur Level-Select-Szene

func _on_settings_pressed():
	$ButtonSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")  # Wechselt zur Settings-Szene (oder öffne ein Popup)

func _on_quit_pressed():
	$ButtonSound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()  # Beendet das Spiel


func _on_credits_pressed() -> void:
	$ButtonSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
