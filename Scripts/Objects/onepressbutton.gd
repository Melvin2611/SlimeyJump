extends StaticBody2D

@export var door_path: NodePath
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var door = get_node(door_path)

var is_pressed = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	animated_sprite.play("up")

func _on_body_entered(body):
	if body is RigidBody2D:
		if not is_pressed:
			is_pressed = true
			animated_sprite.play("down")
			if door:
				door.open_door()

func _on_body_exited(body):
	if body is RigidBody2D:
		pass
