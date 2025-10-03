extends AnimatedSprite2D

var speed = 300
var start_x = 1268
var end_x = -300

func _ready():
	position.y = -346

func _process(delta):
	position.x -= speed * delta
	if position.x <= end_x:
		hide()
