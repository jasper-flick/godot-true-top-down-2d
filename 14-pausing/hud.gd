extends CanvasLayer

@export var map_name_label: Label
@export var map_time_label: Label
@export var map_detector_count_label: Label
@export var map_travel_distance: Label
@export var new_best_map_scores_label: Label

var map_time_text: String
var map_travel_distance_text: String


func _ready() -> void:
	visible = false
	new_best_map_scores_label.visible = false


func show_map_info(map: GameMap) -> void:
	if map.has_best_time():
		map_time_text = "%%ds (%ds)" % map.get_best_time()
	else:
		map_time_text = "%ds"
	
	if map.has_best_travel_distance():
		map_travel_distance_text = (
				"%%dpx (%dpx)" % map.get_best_travel_distance()
		)
	else:
		map_travel_distance_text = "%dxp"
	
	map_name_label.text = map.map_name
	show_map_time(0.0)
	show_travel_distance(0.0)
	visible = true
	new_best_map_scores_label.visible = false


func show_map_time(time: float) -> void:
	map_time_label.text = map_time_text % time


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
	map_travel_distance.text = map_travel_distance_text % distance
