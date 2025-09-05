extends CanvasLayer

@export var map_name_label: Label
@export var map_time_label: Label
@export var map_detector_count_label: Label
@export var map_travel_distance: Label
@export var new_best_map_scores_label: Label


func _ready() -> void:
	visible = false
	new_best_map_scores_label.visible = false


func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	show_map_time(0.0)
	visible = true
	new_best_map_scores_label.visible = false


func show_map_time(time: float) -> void:
	map_time_label.text = "%ds" % time


## Show new best scores, supply -1 to indicate no new best score.
func show_new_best_map_scores(time: int, travel_distance: int) -> void:
	var s: String
	if time >= 0:
		if travel_distance >= 0:
			s = (
					"New best time: %ds\nNew best travel distance: %dpx" %
					[time, travel_distance]
				)
		else:
			s = "New best time: %ds" % time
	elif travel_distance >= 0:
		s = "New best travel distance: %dpx" % travel_distance
	else:
		return
	
	new_best_map_scores_label.text = s
	new_best_map_scores_label.visible = true


func show_map_detector_count(valid: int, total: int) -> void:
	map_detector_count_label.text = "%d / %d" % [valid, total]


func show_travel_distance(distance: float) -> void:
	map_travel_distance.text = "%dpx" % distance
