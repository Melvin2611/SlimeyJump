extends Control

# Referenz zu den Comic-Buttons (du musst diese in der Szene zuweisen oder per Code finden)
@onready var comic_buttons: Array[TextureButton] = [
	$GridContainer/ComicButton1,
	$GridContainer/ComicButton2,
	$GridContainer/ComicButton3,
	$GridContainer/ComicButton4,
	$GridContainer/ComicButton5,
	$GridContainer/ComicButton6,
	$GridContainer/ComicButton7,
	$GridContainer/ComicButton8,
	$GridContainer/ComicButton9
]

# Referenz zu den Lock-Sprites (angenommen, jedes ComicButton hat ein Kind-Node namens Sprite2D für das Schloss-Icon)
@onready var lock_sprites: Array[Sprite2D] = [
	$GridContainer/ComicButton1/Sprite2D,
	$GridContainer/ComicButton2/Sprite2D,
	$GridContainer/ComicButton3/Sprite2D,
	$GridContainer/ComicButton4/Sprite2D,
	$GridContainer/ComicButton5/Sprite2D,
	$GridContainer/ComicButton6/Sprite2D,
	$GridContainer/ComicButton7/Sprite2D,
	$GridContainer/ComicButton8/Sprite2D,
	$GridContainer/ComicButton9/Sprite2D
]

# Pfade zu den Comic-Szenen (passe an deine Pfade an)
var comic_scenes: Array[String] = [
	"res://Scenes/Comics/Comic_1g.tscn",
	"res://Scenes/Comics/Comic_2g.tscn",
	"res://Scenes/Comics/Comic_3g.tscn",
	"res://Scenes/Comics/Comic_4g.tscn",
	"res://Scenes/Comics/Comic_5g.tscn",
	"res://Scenes/Comics/Comic_6g.tscn",
	"res://Scenes/Comics/Comic_7g.tscn",
	"res://Scenes/Comics/Comic_8g.tscn",
	"res://Scenes/Comics/Comic_9g.tscn"
]

# Back-Button (angenommen, du hast einen Button namens BackButton)
@onready var back_button: TextureButton = $BackButton

func _ready():
	# Verbinde das comics_updated-Signal vom ProgressManager
	ProgressManager.comics_updated.connect(_update_gallery)
	
	# Initiale Aktualisierung
	_update_gallery()
	
	# Verbinde die Buttons
	for i in range(comic_buttons.size()):
		comic_buttons[i].pressed.connect(_on_comic_button_pressed.bind(i))
	
	# Back-Button (passe den Pfad zur Main Menu an)
	back_button.pressed.connect(_on_back_pressed)

# Funktion zum Aktualisieren der Gallery-UI basierend auf freigeschalteten Comics
func _update_gallery():
	for i in range(comic_buttons.size()):
		if ProgressManager.is_comic_unlocked(i):
			comic_buttons[i].disabled = false
			comic_buttons[i].modulate = Color(1, 1, 1, 1)  # Normaler Farbton
			lock_sprites[i].visible = false  # Verstecke das Schloss-Sprite
		else:
			comic_buttons[i].disabled = true
			comic_buttons[i].modulate = Color(0.2, 0.2, 0.2, 0.6)  # Abgedunkelt
			lock_sprites[i].visible = true  # Zeige das Schloss-Sprite

# Wenn ein Comic-Button gedrückt wird
func _on_comic_button_pressed(index: int):
	if ProgressManager.is_comic_unlocked(index):
		get_tree().change_scene_to_file(comic_scenes[index])
	else:
		print("Comic ist locked!")

# Zurück zur Main Menu (passe den Pfad an)
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")  # Beispiel-Pfad
