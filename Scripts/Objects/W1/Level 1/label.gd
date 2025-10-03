extends Label

func _ready() -> void:
	self.text = ": %d" % [Global.level_coin_count]
	if Global.level_coin_count == Global.MAX_COINS_PER_LEVEL:
		self.add_theme_color_override("font_color", Color(1, 1, 0.3))  # Gold-ish color
	else:
		self.add_theme_color_override("font_color", Color(1, 1, 1))  # White (default)
