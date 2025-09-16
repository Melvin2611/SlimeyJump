extends Area2D

@export var target_rotation: float = 180.0
@export var rotation_speed: float = 180.0 # Grad pro Sekunde

var player: RigidBody2D = null
var rotating_to_target: bool = false
var rotating_to_zero: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta):
	if not player:
		return

	# Physics Rotation stoppen
	player.angular_velocity = 0

	# Zielrotation bestimmen
	var goal_rotation = 0.0
	if rotating_to_target:
		goal_rotation = target_rotation
	elif rotating_to_zero:
		goal_rotation = 0.0
	else:
		return

	# Sanft drehen
	var diff = goal_rotation - player.rotation_degrees
	if abs(diff) > 0.1:
		player.rotation_degrees += clamp(diff, -rotation_speed * delta, rotation_speed * delta)
	else:
		player.rotation_degrees = goal_rotation
		# Rotation erreicht
		if rotating_to_target:
			rotating_to_target = false
		elif rotating_to_zero:
			rotating_to_zero = false
			player = null

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		rotating_to_target = true
		rotating_to_zero = false
		# Gravitation invertieren deferred
		body.call_deferred("set", "gravity_scale", body.gravity_scale * -1)

func _on_body_exited(body):
	if body == player:
		rotating_to_target = false
		rotating_to_zero = true
		# Gravitation zurücksetzen deferred
		body.call_deferred("set", "gravity_scale", body.gravity_scale * -1)
