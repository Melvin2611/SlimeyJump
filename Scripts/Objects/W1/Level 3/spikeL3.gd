extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("Player"):
		Global.reset_level_coins()
		$AudioStreamPlayer.play()
		if is_inside_tree():
			await get_tree().create_timer(0.2).timeout
			if is_inside_tree():
				get_tree().reload_current_scene()
			else:
				print("Player Death L3")
