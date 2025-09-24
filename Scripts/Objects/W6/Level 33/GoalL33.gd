extends Area2D

@export var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body == player:
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 33/level_33_complete.tscn")
