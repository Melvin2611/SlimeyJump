extends Area2D

@export var speed: float = 100.0 
@export var direction: Vector2 = Vector2.RIGHT  # Richtung (z. B. Vector2.RIGHT für rechts, Vector2.LEFT für links)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play()
	
	if direction == Vector2.LEFT:
		sprite.speed_scale = -1

func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body is RigidBody2D:
				body.linear_velocity.x += direction.x * speed * delta * 60 
				body.linear_velocity.y += direction.y * speed * delta * 60
