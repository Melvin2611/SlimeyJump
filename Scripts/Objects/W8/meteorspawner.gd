extends Node2D

# Exportierte Variable, damit du die zu spawnende Szene im Editor verlinken kannst
@export var scene_to_spawn: PackedScene

# Konfigurierbare Offsets für die Spawn-Positionen (anpassen nach Bedarf)
@export var min_x_offset: float = 200.0  # Minimaler X-Offset rechts von der Kamera
@export var max_x_offset: float = 600.0  # Maximaler X-Offset rechts von der Kamera
@export var min_y_offset: float = -300.0  # Minimaler Y-Offset über der Kamera (negativ, da Y nach unten zunimmt)
@export var max_y_offset: float = -600.0  # Maximaler Y-Offset über der Kamera

# Referenz zur Camera2D (wird in _ready() gesetzt)
var camera: Camera2D

# Array, um die gespawnten Instanzen zu tracken
var spawned_instances: Array[Node] = []

func _ready() -> void:
	# Hole die aktive Camera2D (angenommen, es gibt eine in der Szene)
	camera = get_viewport().get_camera_2d()
	if not camera:
		printerr("Keine Camera2D gefunden! Stelle sicher, dass eine in der Szene existiert.")
		return
	
	# Spawne initial 3 Instanzen
	for i in range(3):
		spawn_one()

func _process(_delta: float) -> void:
	# Entferne ungültige Instanzen manuell (um mögliche Lambda-Probleme zu vermeiden)
	var new_instances: Array[Node] = []
	for inst in spawned_instances:
		if is_instance_valid(inst):
			new_instances.append(inst)
	spawned_instances = new_instances
	
	# Spawne neue, bis wieder 3 existieren
	while spawned_instances.size() < 3:
		spawn_one()

# Funktion zum Spawnen einer neuen Instanz
func spawn_one() -> void:
	if not scene_to_spawn:
		printerr("Keine Szene zum Spawnen zugewiesen!")
		return
	
	# Instanziiere die Szene
	var instance: Node2D = scene_to_spawn.instantiate() as Node2D
	
	# Füge sie als Child hinzu (damit sie in der Szene erscheint)
	add_child(instance)
	
	# Berechne die Spawn-Position basierend auf der Kamera
	var camera_center: Vector2 = camera.get_screen_center_position()
	var spawn_x: float = camera_center.x + randf_range(min_x_offset, max_x_offset)
	var spawn_y: float = camera_center.y + randf_range(min_y_offset, max_y_offset)
	
	# Setze die globale Position
	instance.global_position = Vector2(spawn_x, spawn_y)
	
	# Füge zur Liste hinzu
	spawned_instances.append(instance)
