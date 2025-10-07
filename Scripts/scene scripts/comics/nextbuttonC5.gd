extends Button

func _ready() -> void:
	ProgressManager.unlock_comic(4)

func _pressed() -> void:
	$ButtonSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 25/Level25.tscn")
