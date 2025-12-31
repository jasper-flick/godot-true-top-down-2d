class_name InteractiveObject
extends CharacterBody2D

@export var colission_shape: CollisionShape2D


func get_current_rect() -> Rect2:
	var rect := colission_shape.shape.get_rect()
	rect.position += position
	return rect


func displace(offset: Vector2) -> void:
	position += offset


func push(push_velocity: Vector2) -> void:
	velocity.x = _push(velocity.x, push_velocity.x)
	velocity.y = _push(velocity.y, push_velocity.y)


func _push(speed: float, push_speed: float) -> float:
	if push_speed >= 0.0:
		if speed >= 0.0:
			# Both positive, pick strongest.
			return max(speed, push_speed)
	elif speed < 0.0:
		# Both negative, pick strongest.
		return min(speed, push_speed)
	# Opposite directions, add.
	return speed + push_speed
