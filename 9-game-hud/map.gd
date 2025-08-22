class_name GameMap
extends Node

const KEY_BEST_TIME := "best_time"

@export var map_name := "Map"

var registered_detector_count := 0
var valid_detector_count := 0
var current_map_time := 0.0
var map_save_data: Dictionary


func _process(delta: float) -> void:
	current_map_time += delta
	HUD.show_map_time(current_map_time)
	

func _ready() -> void:
	for child_node in get_children():
		var detector := child_node as Detector
		if detector:
			registered_detector_count += 1
			detector.validity_changed.connect(_on_detector_validity_changed)
	
	Main.map_loaded(self)
	HUD.show_map_info(self)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detector_count += 1
		if valid_detector_count == registered_detector_count:
			_update_best_time()
			Main.load_next_map()
	else:
		valid_detector_count -= 1


func _update_best_time() -> void:
	var new_time := floori(current_map_time)
	if (
			not map_save_data.has(KEY_BEST_TIME)
			or new_time < map_save_data[KEY_BEST_TIME]
	):
		map_save_data[KEY_BEST_TIME] = new_time
		HUD.show_new_best_map_time(new_time)
