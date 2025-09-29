extends Control

@onready var grid_page1: GridContainer = $VBoxContainer/HBoxContainer/GridContainer
@onready var grid_page2: GridContainer = $VBoxContainer/HBoxContainer/GridContainer2
@onready var grid_page3: GridContainer = $VBoxContainer/HBoxContainer/GridContainer3
@onready var left_button: TextureButton = $"Button <"
@onready var right_button: TextureButton = $"Button >"  

var grids: Array[GridContainer]  # Array der Grids für einfachen Zugriff
var current_page: int = 0  # Index: 0=Seite1, 1=Seite2, 2=Seite3
var total_pages: int = 3
var slide_distance: float = 1152.0  # Passe an deine Grid-Breite an, z. B. get_viewport_rect().size.x

func _ready():
	# Fülle das Array mit den Grids (Reihenfolge: Seite1,2,3)
	grids = [grid_page1, grid_page2, grid_page3]
	
	# Verbinde Buttons
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	
	# Initialisiere: Alle bei x=0, aber nur current sichtbar
	for i in range(total_pages):
		grids[i].position.x = 0
		grids[i].visible = (i == current_page)

func _on_left_pressed():
	# Berechne nächsten Index rückwärts (zyklisch: 0->2, 2->1, 1->0)
	var next_page = (current_page - 1 + total_pages) % total_pages
	
	# Animation: Aktueller Grid nach rechts schieben, neuer von links reinschieben
	animate_slide(current_page, next_page, slide_distance, -slide_distance)
	
	current_page = next_page

func _on_right_pressed():
	# Berechne nächsten Index vorwärts (zyklisch: 0->1, 1->2, 2->0)
	var next_page = (current_page + 1) % total_pages
	
	# Animation: Aktueller Grid nach links schieben, neuer von rechts reinschieben
	animate_slide(current_page, next_page, -slide_distance, slide_distance)
	
	current_page = next_page

func animate_slide(current_idx: int, next_idx: int, current_direction: float, next_start: float):
	# Mache nächsten Grid sichtbar und positioniere ihn außerhalb
	grids[next_idx].visible = true
	grids[next_idx].position.x = next_start
	
	# Erstelle Tweens für beide Grids
	var tween_current = create_tween()
	tween_current.tween_property(grids[current_idx], "position:x", current_direction, 0.5)  # Bewege aktuellen Grid weg
	tween_current.tween_callback(func(): 
		grids[current_idx].visible = false  # Blende aus
		grids[current_idx].position.x = 0  # Setze zurück
	)
	tween_current.set_ease(Tween.EASE_IN_OUT)
	tween_current.set_trans(Tween.TRANS_CUBIC)
	
	var tween_next = create_tween()
	tween_next.tween_property(grids[next_idx], "position:x", 0, 0.5)  # Bewege neuen Grid rein
	tween_next.set_ease(Tween.EASE_IN_OUT)
	tween_next.set_trans(Tween.TRANS_CUBIC)
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")


func _on_button_1_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 1/Level1.tscn")


func _on_button_2_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 2/Level2.tscn")


func _on_button_3_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 3/Level3.tscn")


func _on_button_4_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 4/Level4.tscn")


func _on_button_5_pressed() -> void:
	Global.coin_count = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 5/level5.tscn")


func _on_button_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 6/level6.tscn")


func _on_button_7_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 7/Level7.tscn")


func _on_button_8_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 8/level8.tscn")


func _on_button_9_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 9/Level9.tscn")


func _on_button_10_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 10/Level10.tscn")


func _on_button_11_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 11/level11.tscn")


func _on_button_12_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 12/Level12.tscn")


func _on_button_13_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 13/level13.tscn")


func _on_button_14_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 14/Level14.tscn")


func _on_button_15_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 15/Level15.tscn")


func _on_button_16_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 16/Level16.tscn")


func _on_button_17_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 17/level17.tscn")


func _on_button_18_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 18/Level18.tscn")


func _on_texture_button_19_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 19/Level19.tscn")


func _on_texture_button_20_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 20/Level20.tscn")


func _on_texture_button_21_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 21/Level21.tscn")


func _on_texture_button_22_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 22/Level22.tscn")


func _on_texture_button_23_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 23/Level23.tscn")


func _on_texture_button_24_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 24/Level24.tscn")


func _on_texture_button_25_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 25/Level25.tscn")


func _on_texture_button_26_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 26/Level26.tscn")


func _on_texture_button_27_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 27/Level27.tscn")


func _on_texture_button_28_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 28/Level28.tscn")


func _on_texture_button_29_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 29/Level29.tscn")


func _on_texture_button_30_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 30/Level30.tscn")


func _on_texture_button_31_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 31/Level31.tscn")


func _on_texture_button_32_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 32/Level32.tscn")


func _on_texture_button_33_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 33/Level33.tscn")


func _on_texture_button_34_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 34/Level34.tscn")


func _on_texture_button_35_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 35/Level35.tscn")


func _on_texture_button_36_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 36/Level36.tscn")


func _on_texture_button_37_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 37/Level37.tscn")


func _on_texture_button_38_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 38/Level38.tscn")


func _on_texture_button_39_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 39/Level39.tscn")


func _on_texture_button_40_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 40/Level40.tscn")


func _on_texture_button_41_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 41/Level41.tscn")


func _on_texture_button_42_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 42/Level42.tscn")


func _on_texture_button_43_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 43/Level43.tscn")
