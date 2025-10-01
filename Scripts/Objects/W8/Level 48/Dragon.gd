extends CharacterBody2D

@export var speed: float = 300.0
@export var rotation_speed: float = 5.0  # Geschwindigkeit der Rotation (in Radiant pro Sekunde)
@export var target: RigidBody2D
@export var area_2d_second: Area2D  # Zweite Area2D
@export var move_speed: float = 1000.0  # Geschwindigkeit für die schnelle Bewegung der Area2D

func _ready() -> void:
	if area_2d_second:
		# Starte den Zyklus für das Erscheinen/Verschwinden der Area2D
		_start_area2d_cycle()

func _physics_process(delta: float) -> void:
	if target:
		# Richtung zum Ziel berechnen
		var direction: Vector2 = (target.global_position - global_position).normalized()
		
		# Bewegung setzen
		velocity = direction * speed
		move_and_slide()
		
		# Zielwinkel berechnen
		var target_angle: float = (target.global_position - global_position).angle()
		# Aktuellen Winkel sanft interpolieren
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func _on_area_2d_body_entered(body: Node) -> void:
	if body == target:
		get_tree().reload_current_scene()

func _on_area_2d_second_body_entered(body: Node) -> void:
	if body == target:
		get_tree().reload_current_scene()

func _start_area2d_cycle() -> void:
	while true:
		if area_2d_second:
			# Kollisionserkennung aktivieren
			area_2d_second.monitoring = true
			
			# Schnelle Bewegung der Area2D um 50px nach innen (relativ zur Richtung des Characters)
			var move_direction = -global_transform.x.normalized()  # Entlang der X-Achse des Characters (nach innen)
			var target_position = area_2d_second.position + move_direction * 50.0
			var tween = create_tween()
			tween.tween_property(area_2d_second, "position", target_position, 50.0 / move_speed)
			await tween.finished
			
			# Area2D verstecken und Kollisionserkennung deaktivieren
			area_2d_second.hide()
			area_2d_second.monitoring = false
			
			# 5 Sekunden warten
			await get_tree().create_timer(4.5).timeout
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(0.5).timeout
			
			# Area2D wieder anzeigen und um 50px nach außen bewegen
			area_2d_second.show()
			area_2d_second.monitoring = true
			target_position = area_2d_second.position - move_direction * 50.0
			tween = create_tween()
			tween.tween_property(area_2d_second, "position", target_position, 50.0 / move_speed)
			await tween.finished
			
			# 2 Sekunden warten, bevor der Zyklus neu beginnt
			$AudioStreamPlayer2D.stop()
			await get_tree().create_timer(2.0).timeout
