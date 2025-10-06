extends Label

func _ready() -> void:
	self.text = ": %d / 144" % [Global.global_coin_count]
	if Global.global_coin_count == 144:
		self.add_theme_color_override("font_color", Color(1, 1, 0.3))  # Gold-ish color
	else:
		self.add_theme_color_override("font_color", Color(1, 1, 1))  # White (default)
