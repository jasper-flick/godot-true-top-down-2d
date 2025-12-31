class_name MovableObject
extends InteractiveObject

@export_range(0.0, 10.0) var drag := 5.0
@export_range(0.0, 1.0) var impact_response := 0.5
@export var initial_velocity := Vector2.ZERO


func _ready() -> void:
	velocity = initial_velocity


func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * impact_response


func _physics_process(delta: float) -> void:
	if velocity.length_squared() > 1.0:
		if move_and_slide():
			resolve_collisions()
		velocity *= 1.0 - drag * delta
	else:
		position = round(position)
		velocity = Vector2.ZERO


func resolve_collisions() -> void:
	var current_velocity := velocity
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			apply_impact(body.velocity)
			body.apply_impact(current_velocity)
		else:
			velocity -= velocity.project(collision.get_normal())
