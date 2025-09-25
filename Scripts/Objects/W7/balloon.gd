extends Node2D

@export var start_position: Vector2 = Vector2.ZERO
@export var speed: float = 50.0  # Pixels per second, adjustable in editor

var player_count: int = 0

func _ready():
	if start_position == Vector2.ZERO:
		start_position = position  # Default to initial position if not set

func _physics_process(delta: float):
	if player_count > 0:
		# Move up slowly when player is on (y decreases to go up)
		position.y -= speed * delta
	else:
		# Move down to start position if above it (y increases to go down)
		if position.y < start_position.y:
			position.y += speed * delta
		else:
			position.y = start_position.y  # Snap to position if overshot

func _on_area_2d_body_entered(body: Node):
	if body.is_in_group("Player"):
		player_count += 1

func _on_area_2d_body_exited(body: Node):
	if body.is_in_group("Player"):
		player_count -= 1
		if player_count < 0:
			player_count = 0
