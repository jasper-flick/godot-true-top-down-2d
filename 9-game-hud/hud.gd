extends CanvasLayer

@export var map_name_label: Label
@export var map_time_label: Label
@export var new_best_map_time_label: Label


func _ready() -> void:
	visible = false
	new_best_map_time_label.visible = false


func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	show_map_time(0.0)
	visible = true
	new_best_map_time_label.visible = false


func show_map_time(time: float) -> void:
	map_time_label.text = "%ds" % time


func show_new_best_map_time(new_time: int):
	new_best_map_time_label.text = "New best time: %ds" % new_time
	new_best_map_time_label.visible = true
