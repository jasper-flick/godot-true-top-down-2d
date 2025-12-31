class_name TeleporterSource
extends Area2D

## Color for when the teleporter is free.
@export var valid_color := Color(Color.CYAN, 0.5)
## Color for when the teleporter is occupied.
@export var invalid_color := Color(Color.MAGENTA, 0.5)

@export var sprite: Sprite2D

@export var line: Line2D

@export var colissionShape: CollisionShape2D

@export var particles: GPUParticles2D

@export var destination: TeleporterDestination

var is_active := true

var objects: Array[InteractiveObject] = []


func _ready() -> void:
	if not destination:
		is_active = false
		sprite.modulate = invalid_color
		set_physics_process(false)
	else:
		destination.validity_changed.connect(_on_detector_validity_changed)
		sprite.modulate = valid_color
		destination.sprite.modulate = valid_color
		particles.modulate = valid_color
		destination.particles.modulate = valid_color
		line.modulate = valid_color
		line.add_point(Vector2.ZERO)
		line.add_point(destination.position - position)


func _physics_process(_delta: float) -> void:
	if not is_active or objects.is_empty():
		set_physics_process(false)
		return
	objects.is_empty()
	var own_rect := colissionShape.shape.get_rect()
	own_rect.position += position
	
	for object in objects:
		if own_rect.encloses(object.get_current_rect()):
			object.displace(destination.position - position)
			particles.emitting = true
			destination.particles.emitting = true


func _on_detector_validity_changed(valid: bool) -> void:
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
