extends Area2D

@export var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)
	Global.set_current_level("Level 12")
func _on_body_entered(body: Node):
	if body == player:
		$AudioStreamPlayer.play()
		await get_tree().create_timer(3.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 12/level_12_complete.tscn")
