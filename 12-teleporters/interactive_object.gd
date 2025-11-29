class_name InteractiveObject
extends CharacterBody2D

@export var colission_shape: CollisionShape2D


func get_current_rect() -> Rect2:
	var rect := colission_shape.shape.get_rect()
	rect.position += position
	return rect


func displace(offset: Vector2) -> void:
	position += offset
