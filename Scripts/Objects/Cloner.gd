extends Area2D

@export var trigger_body: RigidBody2D  # Der RigidBody2D, der die Area2D betritt
@export var target_body: RigidBody2D   # Der RigidBody2D, der gezeigt/versteckt werden soll

func _ready():
	target_body.hide()  # Verstecke den target_body beim Start
	body_entered.connect(_on_body_entered)  # Verbinde das Signal (falls nicht schon im Editor verbunden)

func _on_body_entered(body: Node2D):
	if body == trigger_body:
		await get_tree().create_timer(0.2).timeout
		target_body.show()  # Zeige den target_body, wenn der trigger_body eintritt
