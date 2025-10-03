extends Area2D

@export var coin_id: String = ""  # Eindeutige ID für die Münze, im Editor zu setzen

func _ready():
	if Global.is_coin_collected(Global.current_level, coin_id):
		queue_free()  # Entferne Münze, wenn sie bereits gesammelt wurde

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not Global.is_coin_collected(Global.current_level, coin_id):
		Global.collect_coin(coin_id)  # Münze mit coin_id sammeln
		$AudioStreamPlayer2D.play()
		queue_free()  # Münze löschen
