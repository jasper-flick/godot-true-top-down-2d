@tool
extends StaticBody2D

@export_range(12, 400) var length := 32 :
	set(new_length):
		length = new_length
		if line and line.points.size() == 2 and line.points[1].x != length:
			line.points[1] = Vector2(length, 0.0)
			collision_shape.position = Vector2(length * 0.5, 0.0)
			var rect := collision_shape.shape as RectangleShape2D
			rect.size = Vector2(length, 8.0)
		
		if line:
			line.material.set(
					"shader_parameter/segment_count",
					length / 8.0
			)

@export var collision_shape: CollisionShape2D
@export var line: Line2D

func _ready() -> void:
	if line:
		line.material.set(
				"shader_parameter/pulse_offsets",
				Vector4(randf(), randf(), randf(), randf()) * (length / 8.0)
		)
		line.material.set(
				"shader_parameter/pulse_speeds",
				Vector4(
						randf_range(1.8, 2.2),
						randf_range(5.5, 6.5),
						randf_range(-3.6, -4.4),
						randf_range(-7.6, -8.4),
				)
		)
		line.material.set(
				"shader_parameter/wave_wiggles_speeds",
				Vector4(
						randf_range(1.0, 3.0),
						randf_range(3.5, 4.5),
						randf_range(9.0, 11.0),
						randf_range(-7.0, -9.0),
				)
		)
