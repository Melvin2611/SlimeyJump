extends Area2D

@export var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)
	Global.set_current_level("Level 48")
func _on_body_entered(body: Node):
	if body == player:
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(3.6).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 48/level_48_complete.tscn")
