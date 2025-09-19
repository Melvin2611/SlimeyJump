extends Area2D

@export var push_force: float = 50.0


var affected_bodies: Array[RigidBody2D] = []
var wind_active: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	wind_active = true

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body not in affected_bodies:
		affected_bodies.append(body)

func _on_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		affected_bodies.erase(body)

func _physics_process(delta: float) -> void:
	for body in affected_bodies:
		body.apply_central_force(Vector2(-push_force, 0))
		wind_active = false
