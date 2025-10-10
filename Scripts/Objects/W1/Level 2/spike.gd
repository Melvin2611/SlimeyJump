extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("Player"):
		Global.reset_level_coins()
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.2).timeout
		get_tree().reload_current_scene()
