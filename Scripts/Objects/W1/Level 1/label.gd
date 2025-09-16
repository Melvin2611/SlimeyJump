extends Label

@export var coin_label: Node

func _ready() -> void:
	coin_label.text = ": %d" % [Global.coin_count]
	if Global.coin_count == Global.MAX_COINS:
		coin_label.add_theme_color_override("font_color", Color(1, 1, 0.3))  # Rot färben
	else:
		coin_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weiß (Standard)
