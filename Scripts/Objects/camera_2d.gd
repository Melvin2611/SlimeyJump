extends Camera2D

@export var follow_speed: float = 5.0
@export var custom_offset: Vector2 = Vector2.ZERO
@export var lookahead_time: float = 0.3
@export var lookahead_smoothing: float = 0.15

var target: RigidBody2D
var current_lookahead: Vector2 = Vector2.ZERO

func _ready():
	make_current()
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed

func _process(delta):
	var players = get_tree().get_nodes_in_group("Player")
	var visible_players: Array = []

	for p in players:
		if p is RigidBody2D and p.is_visible_in_tree():
			visible_players.append(p)

	if visible_players.size() > 0:
		target = _get_closest_player(visible_players)

		if target:
			# Nutze jetzt die lineare Velocity statt Positionsdifferenz
			var desired_lookahead = target.linear_velocity * lookahead_time
			current_lookahead = current_lookahead.lerp(desired_lookahead, lookahead_smoothing)

			global_position = target.global_position + custom_offset + current_lookahead
	else:
		target = null
		current_lookahead = Vector2.ZERO

func _get_closest_player(players: Array) -> RigidBody2D:
	var closest: RigidBody2D = players[0]
	var min_dist: float = global_position.distance_to(players[0].global_position)

	for p in players:
		var dist = global_position.distance_to(p.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = p

	return closest
