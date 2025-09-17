extends Camera2D

@export var follow_speed: float = 5.0
@export var zoom_speed: float = 2.0
@export var custom_offset: Vector2 = Vector2.ZERO  
@export var min_zoom: Vector2 = Vector2(0.3, 0.3)
@export var max_zoom: Vector2 = Vector2(3.0, 3.0)
@export var padding: float = 150.0  # Extra Platz um die Spieler
@export var right_bias: float = 200.0  # Verschiebung nach rechts für mehr Sicht

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
		# Berechne Zoom und Position, um alle sichtbaren Spieler einzuschließen
		var target_position = _update_position_and_zoom(visible_players)

		# Bewege die Kamera zur Zielposition
		if target_position:
			global_position = global_position.lerp(target_position + custom_offset, follow_speed * delta)
	else:
		# Zoom zurücksetzen, wenn keine Spieler sichtbar
		_reset_zoom()

func _update_position_and_zoom(players: Array) -> Vector2:
	var min_pos = Vector2(INF, INF)
	var max_pos = Vector2(-INF, -INF)

	# Berechne die Bounding Box aller sichtbaren Spieler
	for p in players:
		var pos = p.global_position
		min_pos.x = min(min_pos.x, pos.x)
		min_pos.y = min(min_pos.y, pos.y)
		max_pos.x = max(max_pos.x, pos.x)
		max_pos.y = max(max_pos.y, pos.y)

	# Berechne den Mittelpunkt der Bounding Box
	var center = (min_pos + max_pos) / 2

	# Füge einen Bias nach rechts hinzu, um mehr Sicht in diese Richtung zu ermöglichen
	var biased_center = center + Vector2(right_bias, 0)

	# Berechne den Zoom
	var size = max_pos - min_pos

	# Erweitere die Bounding Box für den Zoom, um den Bias zu berücksichtigen
	var effective_size = size + Vector2(right_bias, 0)

	# Berechne den erforderlichen Zoom, um alle Spieler einzuschließen
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom_x = viewport_size.x / (effective_size.x + padding * 2)
	var zoom_y = viewport_size.y / (effective_size.y + padding * 2)

	# Nimm den kleineren Zoom-Wert, um sicherzustellen, dass alles sichtbar ist
	var target_zoom = Vector2(min(zoom_x, zoom_y), min(zoom_x, zoom_y))

	# Begrenze den Zoom
	target_zoom.x = clamp(target_zoom.x, min_zoom.x, max_zoom.x)
	target_zoom.y = clamp(target_zoom.y, min_zoom.y, max_zoom.y)

	# Lerpe zum Ziel-Zoom
	zoom = zoom.lerp(target_zoom, zoom_speed * get_process_delta_time())

	# Stelle sicher, dass alle Spieler im Frame bleiben
	var viewport_half = viewport_size / (2.0 * target_zoom)
	var left_edge = biased_center.x - viewport_half.x
	var right_edge = biased_center.x + viewport_half.x

	# Überprüfe, ob die Spieler noch im Frame sind, und passe die Position an
	if min_pos.x < left_edge + padding:
		biased_center.x += (min_pos.x - (left_edge + padding))
	if max_pos.x > right_edge - padding:
		biased_center.x += (max_pos.x - (right_edge - padding))

	return biased_center

func _reset_zoom():
	zoom = zoom.lerp(Vector2.ONE, zoom_speed * get_process_delta_time())
