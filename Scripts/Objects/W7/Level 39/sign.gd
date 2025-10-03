extends Sprite2D

func _ready() -> void:
	show()
	await get_tree().create_timer(4.2).timeout
	hide()
