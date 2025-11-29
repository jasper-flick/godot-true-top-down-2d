class_name PlayerCharacter
extends InteractiveObject

## Speed in pixels per second.
@export_range(0, 1000) var speed := 60

var last_position: Vector2
var travel_distance := 0.0


func displace(offset: Vector2) -> void:
	super(offset)
	last_position = position


func _ready() -> void:
	last_position = position


func _process(_delta: float) -> void:
	HUD.show_travel_distance(travel_distance)


func _physics_process(_delta: float) -> void:
	get_player_input()
	if move_and_slide():
		resolve_collisions()
	
	travel_distance += last_position.distance_to(position)
	last_position = position


func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)


func get_player_input() -> void:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed
