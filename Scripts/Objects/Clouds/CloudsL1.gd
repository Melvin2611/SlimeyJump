extends AnimatedSprite2D

# Bewegungsgeschwindigkeit der Wolke (Pixel pro Sekunde)
var speed = randf_range(150.0, 600.0)
# Ziel- und Startpositionen
var start_x = 5100.0
var end_x = -285.0
# Bereich für zufällige y-Koordinate
var min_y = 110.0
var max_y = -800.0

var min_S = 3.0
var max_S = 10.0

func _ready():
	# Setze die Startposition und zufällige Skalierung
	position.y = randf_range(min_y, max_y)
	set_random_scale()

func _process(delta):
	# Bewege die Wolke nach links
	position.x -= speed * delta
	# Wenn die Wolke den linken Rand erreicht
	if position.x <= end_x:
		# Teleportiere zurück nach rechts mit neuer zufälliger y-Koordinate und Skalierung
		position.x = start_x
		position.y = randf_range(min_y, max_y)
		set_random_scale()

# Funktion zum Setzen einer zufälligen Skalierung für x und y
func set_random_scale():
	var scale_value = randf_range(min_S, max_S)
	scale = Vector2(scale_value, scale_value)
