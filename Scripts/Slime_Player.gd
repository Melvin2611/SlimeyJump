extends RigidBody2D

# Variablen für die Mechanik
var is_aiming = false
var aim_start_pos: Vector2
var aim_current_pos: Vector2
@export var max_drag_distance = 500.0
@export var force_multiplier = 4.0
var is_on_ground = false
var has_squished = false
var air_fling_count = 0
var max_air_flings = 1
var current_platform: Node = null
var ignore_platform_next_frame = false  # Flag gegen Stuck nach Fling

# Neue exportierte Variable für die Versteck-Mechanik
@export var hide_on_hit_group: String = "hide_triggers"

# Referenz zum AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	set_process_input(true)
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp = 0.5
	# Connect signals für Animation-Triggers
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	if animated_sprite.sprite_frames:
		animated_sprite.sprite_frames.set_animation_loop("squish", false)

# Ground-Detection: Mit colliding_bodies für Animationen
func _physics_process(_delta: float):
	var colliding_bodies = get_colliding_bodies()
	var was_on_ground = is_on_ground
	is_on_ground = false
	current_platform = null

	for body in colliding_bodies:
		if body is TileMapLayer or body.is_in_group("platforms"):
			is_on_ground = true
			if body.is_in_group("platforms") and body.has_method("get_delta"):
				current_platform = body
			break

	if is_on_ground != was_on_ground:
		if is_on_ground:
			air_fling_count = 0
			has_squished = false
		_animation()

	_animation()
	ignore_platform_next_frame = false

# Plattform-Sync: In integrate_forces mit Contacts und Setzen
func _integrate_forces(state: PhysicsDirectBodyState2D):
	if ignore_platform_next_frame:
		return  # Skip nach Fling

	var has_platform_contact = false
	var platform: Node = null
	var platform_direction_type = 0  # Default horizontal

	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		if normal.y > 0.5 and collider.is_in_group("platforms") and collider.has_method("get_delta"):
			has_platform_contact = true
			platform = collider
			platform_direction_type = platform.direction_type if "direction_type" in platform else 0
			break

	if has_platform_contact and platform:
		var platform_delta: Vector2 = platform.get_delta()
		var platform_velocity = platform_delta / state.step
		if platform_direction_type == 0:
			state.linear_velocity.x = platform_velocity.x
		else:
			state.linear_velocity.y = platform_velocity.y

# Signals für zusätzliche Triggers
func _on_body_entered(body: Node):
	if body is TileMapLayer or body.is_in_group("platforms"):
		_animation()
	
	# Neue Versteck-Logik: Verstecke den Player, wenn er einen Body in der exportierten Gruppe trifft
	if not hide_on_hit_group.is_empty() and body.is_in_group(hide_on_hit_group):
		animated_sprite.visible = false
		linear_velocity = Vector2.ZERO  # Optional: Stoppe die Bewegung

func _on_body_exited(body: Node):
	if body is TileMapLayer or body.is_in_group("platforms"):
		_animation()

# Animation fertig
func _on_animation_finished():
	if is_on_ground and animated_sprite.animation == "squish":
		has_squished = true
		_animation()

# Input-Check (entfernt, da Berührungen von überall akzeptiert werden)
# func _is_input_on_slime(input_pos: Vector2) -> bool: ... (nicht mehr benötigt)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and (is_on_ground or air_fling_count < max_air_flings):
			is_aiming = true
			aim_start_pos = get_global_mouse_position()  # Setze auf ersten Touch-Punkt
			aim_current_pos = get_global_mouse_position()
			linear_velocity = Vector2.ZERO
			_animation()
			queue_redraw()
		elif not event.pressed and is_aiming:
			is_aiming = false
			ignore_platform_next_frame = true
			_animation()
			queue_redraw()
			_apply_impulse()
			if not is_on_ground:
				air_fling_count += 1
	elif event is InputEventMouseMotion and is_aiming:
		aim_current_pos = get_global_mouse_position()
		queue_redraw()
	elif event is InputEventScreenTouch:
		var viewport = get_viewport()
		var canvas_transform = viewport.get_canvas_transform()
		var touch_global = canvas_transform.affine_inverse() * event.position
		if event.pressed and (is_on_ground or air_fling_count < max_air_flings):
			is_aiming = true
			aim_start_pos = touch_global  # Setze auf ersten Touch-Punkt
			aim_current_pos = touch_global
			linear_velocity = Vector2.ZERO
			_animation()
			queue_redraw()
		elif not event.pressed and is_aiming:
			is_aiming = false
			ignore_platform_next_frame = true
			_animation()
			queue_redraw()
			_apply_impulse()
			if not is_on_ground:
				air_fling_count += 1
	elif event is InputEventScreenDrag and is_aiming:
		var viewport = get_viewport()
		var canvas_transform = viewport.get_canvas_transform()
		var drag_global = canvas_transform.affine_inverse() * event.position
		aim_current_pos = drag_global
		queue_redraw()

# Draw Trajectory
func _draw():
	if is_aiming:
		# aim_start_pos bleibt der erste Touch-Punkt, nicht mehr auf global_position setzen
		var drag_vector = aim_current_pos - aim_start_pos
		if drag_vector.length() > max_drag_distance:
			drag_vector = drag_vector.normalized() * max_drag_distance
			aim_current_pos = aim_start_pos + drag_vector
		var start_point = to_local(aim_start_pos)
		var end_point = to_local(aim_current_pos)
		var num_dots = 10
		var max_radius = 20.0
		var min_radius = 5.0
		for i in range(num_dots + 1):
			var t = float(i) / num_dots
			var point = start_point.lerp(end_point, t)
			var radius = max_radius - (max_radius - min_radius) * t
			draw_circle(point, radius, Color(0.4, 0.4, 0.4, 0.5))

# Apply Impulse
func _apply_impulse():
	var drag_vector = aim_start_pos - aim_current_pos
	var force = drag_vector * force_multiplier
	var max_force = 1000.0
	if force.length() > max_force:
		force = force.normalized() * max_force
	apply_central_impulse(force)
	_animation()

# Animation
func _animation():
	if is_aiming:
		if animated_sprite.animation != "charge":
			animated_sprite.play("charge")
	elif is_on_ground:
		if not has_squished and animated_sprite.animation != "squish":
			animated_sprite.play("squish")
		elif has_squished and animated_sprite.animation != "idle":
			animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "fling":
			animated_sprite.play("fling")
			$SlimeJump.play()
