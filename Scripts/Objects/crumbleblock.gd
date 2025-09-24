extends Area2D

# Referenzen zu den Child-Nodes
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # Area's Collision
@onready var static_collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D  # StaticBody's Collision

# Timer für die Verzögerungen
var crumble_timer: Timer
var respawn_timer: Timer

func _ready():
	# Timer erstellen
	crumble_timer = Timer.new()
	crumble_timer.wait_time = 1.5
	crumble_timer.one_shot = true
	add_child(crumble_timer)
	crumble_timer.timeout.connect(_on_crumble_timeout)
	
	respawn_timer = Timer.new()
	respawn_timer.wait_time = 5.0
	respawn_timer.one_shot = true
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn_timeout)
	
	# Signals für body_entered und body_exited verbinden
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Initiale Animation setzen
	animated_sprite.play("default")

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player") and body.name == "SlimePlayer":
		body.is_on_ground = true
		body.air_fling_count = 0
		body.has_squished = false
		body.get_node("AnimatedSprite2D").play("idle")  # Spiele die 'idle' Animation des Players
		animated_sprite.play("crumble")
		crumble_timer.start()

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player") and body.name == "SlimePlayer":
		body.is_on_ground = false

func _on_crumble_timeout():
	# Block verstecken und Collisions deaktivieren
	animated_sprite.visible = false
	collision_shape.disabled = true
	static_collision_shape.disabled = true
	
	# Manuell is_on_ground auf false setzen und Player wecken, falls nötig
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player") and body.name == "SlimePlayer":
			body.is_on_ground = false
			body.sleeping = false  # Weckt den RigidBody, um sicherzustellen, dass er fällt
	
	respawn_timer.start()

func _on_respawn_timeout():
	# Block wieder zeigen, Animation zurücksetzen und Collisions aktivieren
	animated_sprite.visible = true
	animated_sprite.play("default")
	collision_shape.disabled = false
	static_collision_shape.disabled = false
