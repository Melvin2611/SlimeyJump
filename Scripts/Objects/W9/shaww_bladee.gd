extends Area2D

@export var point_a: Vector2
@export var point_b: Vector2
@export var speed: float = 100.0  # Geschwindigkeit in Pixeln pro Sekunde

var moving_to_b: bool = true
var progress: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("Player"):
		Global.reset_level_coins()
		$AudioStreamPlayer.play()
		if is_inside_tree():
			await get_tree().create_timer(0.2).timeout
			if is_inside_tree():
				get_tree().reload_current_scene()
			else:
				print("Player Death lul")
				
func _physics_process(delta: float) -> void:
	if point_a == null or point_b == null:
		return
	
	# Geschwindigkeit relativ zur Distanz berechnen
	var distance = point_a.distance_to(point_b)
	var step = speed * delta / distance
	
	if moving_to_b:
		progress += step
		if progress >= 1.0:
			progress = 1.0 - (progress - 1.0)  # Fortschritt umkehren
			moving_to_b = false
	else:
		progress -= step
		if progress <= 0.0:
			progress = -progress  # Fortschritt umkehren
			moving_to_b = true
	
	# Position mittels linearer Interpolation berechnen
	position = point_a.lerp(point_b, progress)
