extends Area2D

@export var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)
	Global.set_current_level("Level 20")
	
func _on_body_entered(body: Node):
	if body == player:
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 20/level_20_complete.tscn")
