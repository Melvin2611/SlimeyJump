extends Area2D

@export var push_force: float = 50.0
@export var wind_duration: float = 10.0
@export var pause_duration: float = 5.0

var affected_bodies: Array[RigidBody2D] = []
var wind_active: bool = true
var timer: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D2.play("default")
	$AnimatedSprite2D3.play("default")
	$AnimatedSprite2D4.play("default")
	wind_active = true
	timer = wind_duration

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body not in affected_bodies:
		affected_bodies.append(body)

func _on_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		affected_bodies.erase(body)

func _physics_process(delta: float) -> void:
	timer -= delta
	if wind_active:
		for body in affected_bodies:
			body.apply_central_force(Vector2(-push_force, 0))
		if timer <= 0:
			wind_active = false
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D2.stop()
			$AnimatedSprite2D3.stop()
			$AnimatedSprite2D4.stop()
			timer = pause_duration
	else:
		if timer <= 0:
			$AudioStreamPlayer.play()
			$AnimatedSprite2D.play("default")
			$AnimatedSprite2D2.play("default")
			$AnimatedSprite2D3.play("default")
			$AnimatedSprite2D4.play("default")
			wind_active = true
			timer = wind_duration
