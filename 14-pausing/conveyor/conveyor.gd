@tool
extends Area2D

@export_range(12, 400) var length := 32 :
	set(new_length):
		length = new_length
		if line and line.points.size() == 2 and line.points[1].x != length:
			line.points[1] = Vector2(length, 0.0)
			collision_shape.position = Vector2(length * 0.5, 0.0)
			var rect := collision_shape.shape as RectangleShape2D
			rect.size = Vector2(length, 12.0)

## Conveyor speed, in pixels per second.
@export_range(0, 60) var speed := 30 :
	set(new_speed):
		speed = new_speed
		if line:
			line.material.set(
					"shader_parameter/speed",
					speed / line.texture.get_size().x
			)

@export var collision_shape: CollisionShape2D
@export var line: Line2D


var objects: Array[InteractiveObject] = []


func _physics_process(_delta: float) -> void:
	if objects.is_empty():
		set_physics_process(false)
		return
	
	var push_velocity = transform.x * speed
	for object in objects:
		object.push(push_velocity)


func _on_body_entered(body: Node2D) -> void:
	var object := body as InteractiveObject
	if object:
		objects.push_back(object)
		set_physics_process(true)


func _on_body_exited(body: Node2D) -> void:
	var index_to_remove := objects.find(body as InteractiveObject)
	if index_to_remove >= 0:
		objects.remove_at(index_to_remove)
