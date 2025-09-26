extends Area2D

@export var push_x: float = 0.0  # Horizontaler Push (positiv: rechts, negativ: links)
@export var push_y: float = 0.0  # Vertikaler Push (positiv: unten, negativ: oben)

var player_inside: RigidBody2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body is RigidBody2D:
		player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = null

func _physics_process(delta: float) -> void:
	if player_inside:
		var push_force = Vector2(push_x, push_y)
		player_inside.apply_central_force(push_force)
