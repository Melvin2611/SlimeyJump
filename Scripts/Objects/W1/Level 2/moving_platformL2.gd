extends AnimatableBody2D
class_name MovingPlatform

@export var speed: float = 100.0
@export var move_distance: float = 200.0
@export_enum("Horizontal", "Vertical") var direction_type: int = 0

var direction: int = 1
var start_position: Vector2
var current_velocity: Vector2 = Vector2.ZERO  # Neu: Velocity für bessere Physik-Sync

func _ready():
	start_position = global_position
	add_to_group("platforms")

func _physics_process(delta: float):
	var move_vector := Vector2.ZERO
	if direction_type == 0:  # Horizontal
		move_vector = Vector2(speed * direction, 0)
	else:  # Vertical
		move_vector = Vector2(0, speed * direction)
	
	current_velocity = move_vector  # Velocity setzen (AnimatableBody2D nutzt das automatisch)
	
	# Position basierend auf Velocity updaten (smoother als direkte Addition)
	global_position += current_velocity * delta
	
	# Richtungswechsel-Logik (unverändert, aber mit Toleranz für Genauigkeit)
	var tolerance: float = 1.0  # Kleine Toleranz, um Oszillationen zu vermeiden
	if direction_type == 0:
		if global_position.x >= start_position.x + move_distance + tolerance:
			direction = -1
		elif global_position.x <= start_position.x - move_distance - tolerance:
			direction = 1
	else:
		if global_position.y >= start_position.y + move_distance + tolerance:
			direction = -1
		elif global_position.y <= start_position.y - move_distance - tolerance:
			direction = 1

# Für Kompatibilität: Gibt die Velocity pro Frame zurück (nutze besser get_platform_velocity() im Spieler)
func get_delta() -> Vector2:
	return current_velocity * get_physics_process_delta_time()
