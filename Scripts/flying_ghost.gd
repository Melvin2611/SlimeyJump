extends CharacterBody2D

@export var speed: float = 100.0  # Geschwindigkeit des Geists (anpassen für "langsam")
@export var gravity: float = 0.0  # Keine Gravitation, da er fliegt (kann angepasst werden)
@export var sprite_scale: float = 1.0  # Basis-Skalierung für den Sprite (anpassbar)
@export var push_strength: float = 100.0  # Stärke, mit der der Geist RigidBody2Ds schiebt

@onready var detection_area: Area2D = $DetectionArea  # Die Area für die Reichweite
@onready var hit_area: Area2D = $HitArea  # Die Area für den Schaden
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Dein Sprite-Node (ändere zu AnimatedSprite2D falls nötig)

var player: Node2D = null  # Referenz zum Spieler
var is_pursuing: bool = false  # Ob der Geist verfolgt

func _ready() -> void:
	# Verbinde Signale
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	hit_area.body_entered.connect(_on_hit_area_body_entered)
	
	# Initiale Skalierung setzen
	sprite.scale = Vector2(sprite_scale, sprite_scale)  # Y bleibt positiv

func _physics_process(delta: float) -> void:
	if is_pursuing and player:
		# Berechne Richtung zum Spieler
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Optional: Gravitation anwenden, falls gewünscht (für leichten Fall)
		velocity.y += gravity * delta
		
		# Flippe den Sprite basierend auf Bewegungsrichtung
		if velocity.x < 0:  # Nach links fliegt/schaut
			sprite.scale.x = sprite_scale  # Positiv (4.0)
		elif velocity.x > 0:  # Nach rechts fliegt/schaut
			sprite.scale.x = -sprite_scale  # Negativ (-4.0)
		
		move_and_slide()
		
		# Überprüfe Kollisionen und schiebe RigidBody2Ds
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is RigidBody2D and not collider.is_in_group("Player"):
				# Wende einen Impuls in die Bewegungsrichtung an, um zu schieben
				var push_direction = velocity.normalized()
				collider.apply_central_impulse(push_direction * push_strength)
	else:
		# Stehen bleiben, wenn kein Spieler in Reichweite
		velocity = Vector2.ZERO

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		is_pursuing = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		is_pursuing = false

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Scene neu laden (Spieler "stirbt")
		get_tree().reload_current_scene()
