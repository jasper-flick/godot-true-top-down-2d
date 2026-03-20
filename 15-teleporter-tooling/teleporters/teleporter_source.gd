@tool
class_name TeleporterSource
extends Area2D

## Color for when the teleporter is free.
@export var valid_color := Color(Color.CYAN, 0.5) :
	set(new_color):
		if new_color != valid_color:
			valid_color = new_color
			particles.modulate = valid_color
			if destination:
				sprite.modulate = valid_color
				destination.sprite.modulate = valid_color
				destination.particles.modulate = valid_color
				line.modulate = valid_color

## Color for when the teleporter is occupied.
@export var invalid_color := Color(Color.MAGENTA, 0.5) :
	set(new_color):
		if new_color != invalid_color:
			invalid_color = new_color
			if not destination:
				sprite.modulate = invalid_color

@export var sprite: Sprite2D

@export var line: Line2D

@export var collision_shape: CollisionShape2D

@export var particles: GPUParticles2D

@export var destination: TeleporterDestination :
	set(new_destination):
		if new_destination != destination:
			if destination:
				destination.position_changed.disconnect(
						_on_destination_position_changed
				)
				destination.validity_changed.disconnect(
						_on_destination_validity_changed
				)
			destination = new_destination
			if not destination:
				sprite.modulate = invalid_color
				line.points[1] = Vector2.ZERO
			else:
				sprite.modulate = valid_color
				destination.sprite.modulate = valid_color
				destination.particles.modulate = valid_color
				line.modulate = valid_color
				line.points[1] = destination.position - position
				destination.position_changed.connect(
						_on_destination_position_changed
				)
				destination.validity_changed.connect(
						_on_destination_validity_changed
				)

var is_active := true

var objects: Array[InteractiveObject] = []


func _ready() -> void:
	if not destination:
		is_active = false
		set_physics_process(false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED and destination:
		line.points[1] = destination.position - position


func _physics_process(_delta: float) -> void:
	if not is_active or objects.is_empty():
		set_physics_process(false)
		return
	objects.is_empty()
	var own_rect := collision_shape.shape.get_rect()
	own_rect.position += position
	
	for object in objects:
		if own_rect.encloses(object.get_current_rect()):
			object.displace(destination.position - position)
			particles.emitting = true
			destination.particles.emitting = true


func _on_destination_position_changed() -> void:
	line.points[1] = destination.position - position


func _on_destination_validity_changed(valid: bool) -> void:
	is_active = valid
	set_physics_process(valid)
	var color := valid_color if valid else invalid_color
	sprite.modulate = color
	destination.sprite.modulate = color
	line.modulate = color


func _on_body_entered(body: Node2D) -> void:
	var object := body as InteractiveObject
	if object:
		objects.push_back(object)
		set_physics_process(true)


func _on_body_exited(body: Node2D) -> void:
	var index_to_remove := objects.find(body as InteractiveObject)
	if index_to_remove >= 0:
		objects.remove_at(index_to_remove)
