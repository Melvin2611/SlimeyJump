extends Label

func _ready() -> void:
	self.text = ": %d" % [Global.coin_count]
	if Global.coin_count == Global.MAX_COINS:
		self.add_theme_color_override("font_color", Color(1, 1, 0.3))  # Gold-ish color
	else:
		self.add_theme_color_override("font_color", Color(1, 1, 1))  # White (default)
