extends StaticBody2D

@export var object1: ColorRect
@export var object2: ColorRect
@export var fade_duration: float = 1.0 # Dauer des Fade-Effekts in Sekunden
@export var fade_step: float = 0.02 # Schrittweite für Alpha-Reduktion pro Frame
@onready var animated_sprite = $AnimatedSprite2D
@onready var area2D = $Area2D

func _ready():
	animated_sprite.play("up")
	# Sicherstellen, dass der Area2D Node Kollisionen erkennt
	area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: RigidBody2D) -> void:
	animated_sprite.play("down")
	# Starte den Fade-Effekt für beide Objekte
	if object1:
		fade_out(object1)
	if object2:
		fade_out(object2)

func fade_out(rect: ColorRect) -> void:
	# Reduziere den Alphawert schrittweise
	var alpha = rect.color.a
	while alpha > 0:
		alpha -= fade_step
		if alpha < 0:
			alpha = 0
		rect.color.a = alpha
		# Warte kurz, um einen flüssigen Übergang zu erzielen
		await get_tree().create_timer(fade_duration * fade_step).timeout
