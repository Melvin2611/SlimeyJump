extends StaticBody2D

@export var door_path: NodePath
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var door = get_node(door_path)

var heavy_bodies_count = 0

func _ready():
	area.body_entered.connect(_on_body_entered)
	animated_sprite.play("up")

func _on_body_entered(body):
	if body is RigidBody2D and body.mass >= 1.2:
		heavy_bodies_count += 1
		if heavy_bodies_count == 1:
			animated_sprite.play("down")
			if door:
				door.open_door()
