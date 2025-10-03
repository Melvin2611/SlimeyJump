extends Sprite2D

func _ready() -> void:
	show()
	await get_tree().create_timer(2.0).timeout
	hide()
