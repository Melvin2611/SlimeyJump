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
@export var max_air_flings = 1
var current_platform: Node = null
var ignore_platform_next_frame = false
var using_controller = false
var is_switching = false
var hide_on_hit_group: String = "hide_triggers"

enum SlimeType { DEFAULT, BLUE, RED, SUPER, LIGHT, UNDERWATERLIGHT, UNDERWATER, UNDERWATERREDLIGHT }

@export var current_slime_type: SlimeType = SlimeType.DEFAULT

# Referenz zum AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

# In _ready() hinzufügen (oder dort, wo du set_process_input(true) aufrufst)
func _ready():
	set_process_input(true)
	input_pickable = true   # damit dieses CollisionObject Pointer-Events bekommt
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp = 0.5
	aim_start_pos = global_position
	aim_current_pos = global_position
	for layer in get_tree().get_nodes_in_group("tilemap_layers"):
		if layer is TileMapLayer:
			layer.collision_friction = 0.05
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	if animated_sprite.sprite_frames:
		animated_sprite.sprite_frames.set_animation_loop("squish", false)
	apply_slime_properties()
	


func apply_slime_properties():
	match current_slime_type:
		SlimeType.DEFAULT:
			gravity_scale = 1.0
			mass = 1.0
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = false
			animated_sprite.play("idle")
			update_animation()

		SlimeType.BLUE:
			gravity_scale = 0.5
			mass = 1.0
			force_multiplier = 8.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = false
			animated_sprite.play("idle_blue")
			update_animation()

		SlimeType.RED:
			gravity_scale = 1.2
			mass = 1.2
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = false
			animated_sprite.play("idle_red")
			update_animation()

		SlimeType.SUPER:
			gravity_scale = 0.8
			mass = 1.0
			force_multiplier = 7.0
			max_air_flings = 2
			if has_node("PointLight2D"):
				$PointLight2D.visible = true
			animated_sprite.play("idle_super")
			update_animation()

		SlimeType.LIGHT:
			gravity_scale = 1.0
			mass = 1.0
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = true
			animated_sprite.play("idle")
			update_animation()
			
		SlimeType.UNDERWATER:
			gravity_scale = 0.5
			mass = 1.0
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = false
			animated_sprite.play("idle")
			update_animation()
			
		SlimeType.UNDERWATERLIGHT:
			gravity_scale = 0.5
			mass = 1.0
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = true
			animated_sprite.play("idle")
			update_animation()
			
		SlimeType.UNDERWATERREDLIGHT:
			gravity_scale = 0.6
			mass = 1.2
			force_multiplier = 4.0
			max_air_flings = 1
			if has_node("PointLight2D"):
				$PointLight2D.visible = true
			animated_sprite.play("idle")
			update_animation()

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
		update_animation()

	update_animation()
	ignore_platform_next_frame = false

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if ignore_platform_next_frame:
		return

	var has_platform_contact = false
	var platform: Node = null
	var platform_direction_type = 0

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

func _on_body_entered(body: Node):
	if body is TileMapLayer or body.is_in_group("platforms"):
		update_animation()
	
	if not hide_on_hit_group.is_empty() and body.is_in_group(hide_on_hit_group):
		animated_sprite.visible = false
		linear_velocity = Vector2.ZERO

func _on_body_exited(body: Node):
	if body is TileMapLayer or body.is_in_group("platforms"):
		update_animation()

func _on_animation_finished():
	if is_on_ground and animated_sprite.animation == "squish":
		has_squished = true
		update_animation()

func reset_state():
	var keep_position = global_position
	print("[RESET] START, global_position=", global_position)

	is_aiming = false
	aim_start_pos = global_position
	aim_current_pos = global_position
	linear_velocity = Vector2.ZERO
	air_fling_count = 0
	has_squished = false
	is_on_ground = false
	current_platform = null
	ignore_platform_next_frame = false
	using_controller = false
	is_switching = true

	animated_sprite.play("idle")

	# Physik 1 Frame aussetzen, damit Position nicht "springt"
	freeze = true
	await get_tree().process_frame
	global_position = keep_position
	freeze = false

	await get_tree().create_timer(0.2).timeout
	is_switching = false

	global_position = keep_position
	print("[RESET] END, global_position=", global_position)


# Dieses neue _input_event ersetzt die "nur wenn auf dem Slime geklickt wurde"-Logik
# Start nur, wenn man den Slime selbst anklickt/antippt
func _input_event(viewport, event, shape_idx):
	if is_switching:
		return

	# 🖱️ Maus- oder Touch-Press auf den Slime selbst startet Aiming
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) \
	or (event is InputEventScreenTouch and event.pressed):
		if is_on_ground or air_fling_count < max_air_flings:
			print("Aim started on slime (input_event)")
			is_aiming = true

			if event is InputEventMouseButton:
				aim_start_pos = get_global_mouse_position()
			else:
				var vp = get_viewport()  # <--- hier der Fix: kein Namenskonflikt mehr
				var canvas_transform = vp.get_canvas_transform()
				var touch_global = canvas_transform.affine_inverse() * event.position
				aim_start_pos = touch_global

			aim_current_pos = aim_start_pos
			linear_velocity = Vector2.ZERO
			update_animation()
			queue_redraw()


# Globales Input — erkennt Loslassen und Ziehen überall
func _input(event):
	if is_switching:
		return

	# Ziehen der Maus oder des Fingers
	if event is InputEventMouseMotion and is_aiming:
		aim_current_pos = get_global_mouse_position()
		queue_redraw()

	elif event is InputEventScreenDrag and is_aiming:
		var viewport = get_viewport()
		var canvas_transform = viewport.get_canvas_transform()
		var drag_global = canvas_transform.affine_inverse() * event.position
		aim_current_pos = drag_global
		queue_redraw()

	# 🖱️ Loslassen (auch außerhalb des Slimes)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and is_aiming:
		print("Mouse released (outside or inside slime)")
		is_aiming = false
		ignore_platform_next_frame = true
		update_animation()
		queue_redraw()
		_apply_impulse()
		if not is_on_ground:
			air_fling_count += 1

	# 📱 Touch loslassen (auch außerhalb)
	elif event is InputEventScreenTouch and not event.pressed and is_aiming:
		print("Touch released (outside or inside slime)")
		is_aiming = false
		ignore_platform_next_frame = true
		update_animation()
		queue_redraw()
		_apply_impulse()
		if not is_on_ground:
			air_fling_count += 1


func _process(_delta: float):
	if is_switching:
		print("Controller input ignored: is_switching is true")
		return

	var stick_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var stick_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	var stick_vector = Vector2(stick_x, stick_y)
	var deadzone = 0.2

	if stick_vector.length() > deadzone and (is_on_ground or air_fling_count < max_air_flings) and not is_aiming:
		print("Controller input: starting aim")
		is_aiming = true
		using_controller = true
		aim_start_pos = global_position
		linear_velocity = Vector2.ZERO
		update_animation()
		queue_redraw()

	if is_aiming and using_controller and stick_vector.length() > deadzone:
		var drag_length = stick_vector.length() * max_drag_distance
		var direction = stick_vector.normalized()
		aim_current_pos = aim_start_pos + direction * drag_length
		queue_redraw()
	elif is_aiming and using_controller and stick_vector.length() <= deadzone:
		print("Controller input released: applying impulse")
		is_aiming = false
		using_controller = false
		ignore_platform_next_frame = true
		update_animation()
		queue_redraw()
		_apply_impulse()
		if not is_on_ground:
			air_fling_count += 1

func _draw():
	if not is_aiming:
		return
	if aim_start_pos == null or aim_current_pos == null:
		return

	var drag_vector = aim_current_pos - aim_start_pos
	if drag_vector == null:
		return

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



func _apply_impulse():
	if is_switching:
		print("Impulse blocked: is_switching is true")
		return

	var drag_vector = aim_start_pos - aim_current_pos
	var drag_length = drag_vector.length()

	# Falls kein Drag vorhanden, abbrechen (keine Richtung)
	if drag_length < 1.0:
		print("Impulse skipped: drag too small")
		return

	# Begrenze Drag auf maximal erlaubte Länge
	if drag_length > max_drag_distance * 2:
		print("Drag vector too large (%.2f), clamping to max allowed." % drag_length)
		drag_vector = drag_vector.normalized() * (max_drag_distance * 2)

	# Berechne Kraft
	var force = drag_vector * force_multiplier

	# Begrenze Kraft, falls zu stark
	var max_force = 1000.0
	if force.length() > max_force:
		print("Force too large (%.2f), clamping to max allowed." % force.length())
		force = force.normalized() * max_force

	print("Applying impulse: aim_start_pos=", aim_start_pos, ", aim_current_pos=", aim_current_pos, ", force=", force, ", global_position=", global_position)

	# Wende den Impuls immer an (niemals blocken)
	apply_central_impulse(force)
	update_animation()


func change_slime(new_type: SlimeType):
	if is_switching:
		return

	is_switching = true
	current_slime_type = new_type

	reset_state()
	apply_slime_properties()

	await get_tree().create_timer(0.3).timeout
	is_switching = false

func get_animation_name(base_name: String) -> String:
	match current_slime_type:
		SlimeType.DEFAULT:
			return base_name
		SlimeType.BLUE:
			return base_name + "_blue"
		SlimeType.RED:
			return base_name + "_red"
		SlimeType.SUPER:
			return base_name + "_super"
		SlimeType.LIGHT:
			return base_name
		SlimeType.UNDERWATERLIGHT:
			return base_name
		SlimeType.UNDERWATERREDLIGHT:
			return base_name + "_red"
		SlimeType.UNDERWATER:
			return base_name
	return base_name

func update_animation():
	if is_aiming:
		var anim_name = get_animation_name("charge")
		if animated_sprite.animation != anim_name:
			animated_sprite.play(anim_name)
			if using_controller:
				Input.start_joy_vibration(0, 0.5, 0.5, 0.5)
			else:
				Input.vibrate_handheld(500)
	elif is_on_ground:
		if not has_squished:
			var anim_name = get_animation_name("squish")
			if animated_sprite.animation != anim_name:
				animated_sprite.play(anim_name)
		else:
			var anim_name = get_animation_name("idle")
			if animated_sprite.animation != anim_name:
				animated_sprite.play(anim_name)
	else:
		var anim_name = get_animation_name("fling")
		if animated_sprite.animation != anim_name:
			animated_sprite.play(anim_name)
			$SlimeJump.play()
