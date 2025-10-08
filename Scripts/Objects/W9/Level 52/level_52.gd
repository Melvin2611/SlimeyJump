extends Node2D

# Referenz zur Raum-Szene (muss im Editor zugewiesen werden)
@export var room_scene: PackedScene
# Breite eines Raums in Pixeln
@export var room_width: float = 640.0
# Anzahl der Räume, die vor und hinter dem Spieler sichtbar sind
@export var visible_rooms: int = 3
# Referenz zum Spieler (muss im Editor zugewiesen oder dynamisch gesetzt werden)
@export var player: Node2D

# Speichert die aktiven Räume
var rooms: Dictionary = {}
# Der Index des aktuell zentralen Raums
var current_room_index: int = 0

func _ready():
	# Initiale Räume laden
	update_rooms()

func _process(_delta):
	# Berechne den aktuellen Raum-Index basierend auf der Spielerposition
	var player_x = player.global_position.x
	var new_room_index = int(player_x / room_width)
	
	# Wenn sich der Spieler in einen neuen Raum bewegt, aktualisiere die Räume
	if new_room_index != current_room_index:
		current_room_index = new_room_index
		update_rooms()

func update_rooms():
	# Bereich der zu ladenden Räume
	var start_index = current_room_index - visible_rooms
	var end_index = current_room_index + visible_rooms
	
	# Entferne Räume, die außerhalb des sichtbaren Bereichs liegen
	for room_index in rooms.keys():
		if room_index < start_index or room_index > end_index:
			rooms[room_index].queue_free()
			rooms.erase(room_index)
	
	# Füge neue Räume hinzu, die im sichtbaren Bereich liegen, außer für Index 0
	for i in range(start_index, end_index + 1):
		if i != 0 and not rooms.has(i):
			var new_room = room_scene.instantiate()
			new_room.global_position = Vector2(i * room_width, 0)
			add_child(new_room)
			rooms[i] = new_room
