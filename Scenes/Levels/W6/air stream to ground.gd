extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_on_ground = true
		body.air_fling_count = 0
		body.has_squished = false

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_on_ground = false
