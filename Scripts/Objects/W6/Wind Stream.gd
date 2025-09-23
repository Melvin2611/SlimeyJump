extends Area2D

@export var wind_strength: float = 1000.0  # Stärke des Winds (nach oben). Passe das an, um den Effekt zu tunen.

var affected_bodies: Array = []

func _ready() -> void:
	# Verbinde die Signale automatisch
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D :  # Ersetze durch body.name == "Player" falls nötig
		affected_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	affected_bodies.erase(body)

func _physics_process(_delta: float) -> void:
	for body in affected_bodies:
		# Wende eine konstante Kraft nach oben an (Y-Achse ist in Godot nach unten positiv, daher negativ für aufwärts)
		body.apply_central_force(Vector2(0, -wind_strength))
