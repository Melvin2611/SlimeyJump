extends StaticBody2D

@export var Node1: Node2D
@export var Node2: Node2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var area2D = $Area2D

func _ready():
	animated_sprite.play("up")
	# Sicherstellen, dass der Area2D Node Kollisionen erkennt
	area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: RigidBody2D) -> void:
	animated_sprite.play("down")
	# Verschiebe die Nodes auf Position (0, 10000)
	if Node1:
		Node1.position = Vector2(0, 10000)
	if Node2:
		Node2.position = Vector2(0, 10000)
