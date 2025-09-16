extends Node2D

@onready var sprite = $Sprite2D
@onready var collision = $StaticBody2D/CollisionShape2D

@export var CLOSED_Y = float(343)
@export var OPEN_Y = float(545.0)
const MOVE_SPEED = 2.0

var target_y = CLOSED_Y
var is_moving = false

func _ready():
	position.y = CLOSED_Y
	collision.disabled = false

func _process(delta):
	if is_moving:
		var current_y = position.y
		position.y = lerp(current_y, target_y, MOVE_SPEED * delta)
		if abs(position.y - target_y) < 0.1:
			position.y = target_y
			is_moving = false

func open_door():
	target_y = OPEN_Y
	is_moving = true
	collision.disabled = true

func close_door():
	target_y = CLOSED_Y
	is_moving = true
	collision.disabled = false
