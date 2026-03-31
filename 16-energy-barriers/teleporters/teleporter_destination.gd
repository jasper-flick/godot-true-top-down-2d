@tool
class_name TeleporterDestination
extends Area2D

signal position_changed
signal validity_changed(valid: bool)

@export var sprite: Sprite2D

@export var particles: GPUParticles2D

var object_count := 0


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		position_changed.emit()


func _on_body_entered(_body: Node2D) -> void:
	if object_count == 0:
		validity_changed.emit(false)
	object_count += 1


func _on_body_exited(_body: Node2D) -> void:
	object_count -= 1
	if object_count == 0:
		validity_changed.emit(true)
