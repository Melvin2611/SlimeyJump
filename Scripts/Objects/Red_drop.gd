extends Area2D

# Referenz auf den versteckten SlimePlayerBlue (im Inspector setzen!)
@export var slime_player_red: RigidBody2D

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.name == "SlimePlayer":
		# Position vom SlimePlayer speichern
		var old_pos: Vector2 = body.global_position

		# SlimePlayer verschwinden lassen (hier: verstecken)
		body.hide()
		body.set_deferred("disabled", true)  # falls du Physics deaktivieren willst

		# Area2D verschwindet
		queue_free()

		# Blauen Slime sichtbar machen und Position setzen
		if slime_player_red:
			slime_player_red.global_position = old_pos
			slime_player_red.show()
			slime_player_red.set_deferred("disabled", false)
