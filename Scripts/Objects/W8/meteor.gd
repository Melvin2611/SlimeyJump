extends Area2D

# Geschwindigkeit des Meteors (nach unten und links)
@export var fall_speed: float = 200.0  # Vertikale Geschwindigkeit (nach unten)
@export var horizontal_speed: float = 100.0  # Horizontale Geschwindigkeit (nach links)

# Interne Velocity-Variable für die Bewegung
var velocity: Vector2 = Vector2.ZERO

# Wird aufgerufen, wenn der Node in die Szene geladen wird
func _ready():
	$PointLight2D.show()
	# Setze die Velocity: negativ x für links, positiv y für unten
	velocity = Vector2(-horizontal_speed, fall_speed)
	# Verbinde das body_entered-Signal, falls nicht schon im Editor getan
	connect("body_entered", _on_body_entered)
	# Verbinde das animation_finished-Signal des AnimatedSprite2D (einmalig)

# Wird jeden Physik-Frame aufgerufen (für gleichmäßige Bewegung)
func _physics_process(delta):
	# Aktualisiere die Position basierend auf der Velocity
	position += velocity * delta


# Kollisions-Handhabung (z.B. mit dem Spieler oder dem Boden)
func _on_body_entered(body):
	if body.is_in_group("Player") and $AnimatedSprite2D.animation == "default":
		get_tree().reload_current_scene()
	elif body is TileMapLayer:  # Prüfe, ob es ein TileMapLayer ist (dein Boden)
		velocity = Vector2.ZERO  # Stoppe die Bewegung, um an Ort zu bleiben
		$AnimatedSprite2D.play("break")  # Spiele die "break"-Animation ab
		$PointLight2D.hide()
		await get_tree().create_timer(1.0).timeout
		queue_free()
