extends Node2D

@export var start_y: float = 0.0  # Start-Position Y (relativ zur aktuellen Position)
@export var end_y: float = -200.0  # End-Position Y (z. B. -200 für 200 Pixel nach oben)
@export var move_speed: float = 0.2  # Dauer der Bewegung in Sekunden (sehr schnell: 0.2s)
@export var trigger_area: Area2D  # Verbinde im Inspector mit deinem Area2D-Node

var has_moved: bool = false  # Sicherstellen, dass es nur einmal passiert
var player_body: RigidBody2D = null  # Referenz auf den Spieler speichern

func _ready():
	# Setze initiale Position
	position.y = start_y
	
	# Verbinde das Signal, falls nicht im Inspector getan
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_area_body_entered)

func _on_trigger_area_body_entered(body: Node2D):
	if has_moved:
		return  # Nur einmal ausführen
	
	if body.is_in_group("Player") and body is RigidBody2D:
		has_moved = true
		player_body = body  # Speichere Referenz auf den Spieler
		
		# Aktiviere Continuous Collision Detection (CCD) für den Spieler
		player_body.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE  # Oder CCD_MODE_CAST_SHAPE, je nach Bedarf
		
		# Starte Tween für schnelle Bewegung nach oben
		var tween = create_tween()
		tween.tween_property(self, "position:y", end_y, move_speed)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		
		# Wenn Tween fertig ist, deaktiviere CCD wieder
		tween.finished.connect(_on_tween_finished)
		# Optional: Sound oder Effekt hier hinzufügen

func _on_tween_finished():
	if player_body:
		player_body.continuous_cd = RigidBody2D.CCD_MODE_DISABLED  # Deaktiviere CCD
		player_body = null  # Referenz löschen, falls nicht mehr benötigt
