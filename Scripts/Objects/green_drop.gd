extends Area2D

# Referenzen im Inspector setzen
@export var slime_player: RigidBody2D
@export var slime_player_other: RigidBody2D

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body == slime_player_other:
		# Position vom blauen Slime speichern
		var old_pos: Vector2 = slime_player_other.global_position

		# Blauen Slime verschwinden lassen
		slime_player_other.hide()
		slime_player_other.set_deferred("disabled", true)

		# Area2D verschwindet
		queue_free()

		# Normalen Slime sichtbar machen und Position setzen
		if slime_player:
			slime_player.global_position = old_pos
			slime_player.show()
			slime_player.set_deferred("disabled", false)
