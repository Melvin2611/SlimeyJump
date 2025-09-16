extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Angenommen, dein Spieler ist in der Gruppe "Player"
		Global.collect_coin()  # Münze sammeln (über Global-Skript)
		$AudioStreamPlayer2D.play()
		queue_free()  # Münze löschen
