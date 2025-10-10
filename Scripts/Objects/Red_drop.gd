extends Area2D

# Referenz auf den versteckten SlimePlayerBlue (im Inspector setzen!)
@export var slime_player_blue: RigidBody2D
@export var target_position: Vector2

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		# Position vom SlimePlayer speichern
		var old_pos: Vector2 = body.global_position

		# SlimePlayer verschwinden lassen (hier: verstecken)
		body.set_deferred("global_position", target_position)
		body.hide()
		body.set_deferred("disabled", true)  # Physics deaktivieren

		# Area2D verschwindet
		queue_free()

		# Blauen Slime sichtbar machen und Position setzen
		if slime_player_blue:
			slime_player_blue.show()
			slime_player_blue.set_deferred("disabled", false)

			# Position deferred setzen, damit Physics-Engine es akzeptiert
			slime_player_blue.set_deferred("global_position", old_pos)
