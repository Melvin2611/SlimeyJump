# TimerBlocks.gd
extends Node2D

@export var block1: Node2D
@export var block2: Node2D
@export var interval: float = 1.0  # Zeit in Sekunden pro Block

var active_block: int = 1
var timer: float = 0.0

func _ready():
	# Zu Beginn nur Block 1 aktiv
	block1.visible = true
	block2.visible = false

func _process(delta):
	timer += delta
	if timer >= interval:
		timer = 0.0
		_switch_blocks()

func _switch_blocks():
	if active_block == 1:
		active_block = 2
		block1.visible = false
		block1.collision_layer = 5
		block2.visible = true
		block2.collision_layer = 2
	else:
		active_block = 1
		block1.visible = true
		block1.collision_layer = 2
		block2.visible = false
		block2.collision_layer = 5
