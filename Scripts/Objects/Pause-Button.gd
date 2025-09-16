extends TextureButton  # Oder TextureButton, je nach Node-Typ

func _on_pause_button_pressed():
	get_tree().paused = true  # Pausiert das gesamte Spiel (Physik, Timer, etc.)
	# Optional: Zeige ein Pause-Menü an (siehe Schritt 4)
	show_pause_menu()
