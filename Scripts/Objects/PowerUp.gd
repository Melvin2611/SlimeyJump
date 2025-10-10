extends Area2D

@export var slime_type: SlimePlayer.SlimeType = SlimePlayer.SlimeType.DEFAULT

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is SlimePlayer:
		body.change_slime(slime_type)
		queue_free()  # PowerUp verschwindet
