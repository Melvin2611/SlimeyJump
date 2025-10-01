extends Area2D

@onready var other_area = $Area2D  # Pfad zur zweiten Area2D, direktes Kind
var has_been_entered = false  # Flag, um zu verfolgen, ob die Area2D bereits betreten wurde

func _ready():
	# Nur die zweite Area2D wird auf monitoring false gesetzt
	other_area.monitoring = false
	other_area.hide()
	# Erste Area2D bleibt monitoring true
	monitoring = true

func _on_body_entered(_body):
	if _body is RigidBody2D and not has_been_entered:
		has_been_entered = true  # Setze das Flag, um weitere Aufrufe zu verhindern
		monitoring = false  # Deaktiviere monitoring für diese Area2D
		other_area.show()
		other_area.monitoring = true
		# Erstelle einen Tween für die Bewegung
		var tween = create_tween()
		tween.tween_property(other_area, "position:y", other_area.position.y - 500, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
