extends Area2D

## Color for when no objects are on the detector.
@export_color_no_alpha var invalid_color := Color.RED
## Color for when objects are on the detector.
@export_color_no_alpha var valid_color := Color.GREEN

## How fast the detector's color pulses.
@export_range(0.1, 1.0) var pulse_frequency := 0.25

@export var sprite: Sprite2D

var object_count := 0

var pulse_progress := 0.0


func _init() -> void:
	pulse_progress = randf()


func _process(delta: float) -> void:
	if object_count == 0:
		pulse_progress += delta * pulse_frequency
		if pulse_progress >= 1.0:
			pulse_progress -= 1.0

		var brightness := cos(pulse_progress * TAU) * 0.25 + 0.75
		sprite.modulate = Color(
				invalid_color.r * brightness,
				invalid_color.g * brightness,
				invalid_color.b * brightness
		)


func _on_body_entered(_body: Node2D) -> void:
	if object_count == 0:
		sprite.modulate = valid_color
	object_count += 1


func _on_body_exited(_body: Node2D) -> void:
	object_count -= 1
	if object_count == 0:
		pulse_progress = 0.0
