extends Area2D

@export var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node):
	print("entered")
	if body == player:
		print("Player entered")
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(3.6).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 51/level_51_complete.tscn")
