extends Camera2D

@export var follow_speed: float = 5.0
@export var custom_offset: Vector2 = Vector2.ZERO  

var target: Node2D = null

func _ready():
	make_current()
	position_smoothing_enabled = false

func _physics_process(delta):
	var players = get_tree().get_nodes_in_group("Player")
	var visible_players: Array = []

	# Nur sichtbare Spieler berücksichtigen
	for p in players:
		if p is Node2D and p.is_visible_in_tree():
			visible_players.append(p)

	if visible_players.size() > 0:
		# Finde den nächstgelegenen sichtbaren Player
		target = _get_closest_player(visible_players)

		# Folge dem Target
		if target:
			var target_position = target.global_position + custom_offset
			global_position = global_position.lerp(target_position, follow_speed * delta)
	else:
		target = null  # Falls keiner sichtbar ist

func _get_closest_player(players: Array) -> Node2D:
	var closest: Node2D = players[0]
	var min_dist: float = global_position.distance_to(players[0].global_position)

	for p in players:
		var dist = global_position.distance_to(p.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = p

	return closest
