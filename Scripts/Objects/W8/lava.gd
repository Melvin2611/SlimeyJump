extends Area2D

@export var amplitude: float = 50.0  # Höhe der Bewegung (in Pixeln)
@export var frequency: float = 1.0   # Geschwindigkeit (kleiner Wert = langsamer)

var initial_position: Vector2
var time: float = 0.0

func _ready():
	initial_position = position  # Speichere die Startposition
	body_entered.connect(_on_body_entered)

func _process(delta):
	time += delta  # Zeit hochzählen
	# Berechne die neue Y-Position mit Sinus-Funktion
	position.y = initial_position.y + amplitude * sin(frequency * time)

func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("Player"):
		Global.reset_level_coins()
		$AudioStreamPlayer.play()
		if is_inside_tree():
			await get_tree().create_timer(0.2).timeout
			if is_inside_tree():
				get_tree().reload_current_scene()
			else:
				print("Player Death L3")
