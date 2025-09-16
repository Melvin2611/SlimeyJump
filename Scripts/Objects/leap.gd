extends Area2D

# - = hoch
@export var catapult_force: float = -1500.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.linear_velocity.y = catapult_force
		$AudioStreamPlayer2D.play()
