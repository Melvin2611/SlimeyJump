extends Area2D

@export var neue_position: Vector2

func _ready():
	# Verbinde das Signal body_entered mit der Funktion
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Prüfe, ob das eintretende Objekt zur Gruppe "Player" gehört
	if body.is_in_group("Player"):
		body.position = neue_position
