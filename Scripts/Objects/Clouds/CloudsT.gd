extends AnimatedSprite2D

# Bewegungsgeschwindigkeit der Wolke (Pixel pro Sekunde)
var speed = randf_range(150.0, 400.0)
# Ziel- und Startpositionen
var start_x = 1240
var end_x = -85.0
# Bereich für zufällige y-Koordinate
var min_y = 50
var max_y = 400

func _ready():
	# Setze die Startposition und zufällige Skalierung
	position.y = randf_range(min_y, max_y)

func _process(delta):
	# Bewege die Wolke nach links
	position.x -= speed * delta
	# Wenn die Wolke den linken Rand erreicht
	if position.x <= end_x:
		# Teleportiere zurück nach rechts mit neuer zufälliger y-Koordinate und Skalierung
		position.x = start_x
		position.y = randf_range(min_y, max_y)
