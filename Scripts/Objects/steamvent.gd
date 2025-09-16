extends Node2D

@onready var collision = $StaticBody2D/CollisionShape2D

@export var CLOSED_Y = float(343)
@export var OPEN_Y = float(545.0)
const MOVE_SPEED = 2.0

var target_y = CLOSED_Y
var is_moving = false
var is_open = false
var timer = 0.0

func _ready():
	position.y = CLOSED_Y
	collision.disabled = false
	is_open = false

func _process(delta):
	if is_moving:
		var current_y = position.y
		position.y = lerp(current_y, target_y, MOVE_SPEED * delta)
		if abs(position.y - target_y) < 0.1:
			position.y = target_y
			is_moving = false
	
	timer += delta
	if timer >= 5.0 and not is_moving:
		timer = 0.0
		toggle_door()

func toggle_door():
	if is_open:
		close_door()
	else:
		open_door()

func open_door():
	target_y = OPEN_Y
	is_moving = true
	collision.disabled = true
	is_open = true

func close_door():
	target_y = CLOSED_Y
	is_moving = true
	collision.disabled = false
	is_open = false
