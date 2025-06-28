extends Node

var registered_detector_count := 0
var valid_detector_count := 0


func _ready() -> void:
	for child_node in get_children():
		var detector := child_node as Detector
		if detector:
			registered_detector_count += 1
			detector.validity_changed.connect(_on_detector_validity_changed)
	
	Main.map_loaded(scene_file_path)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detector_count += 1
		if valid_detector_count == registered_detector_count:
			Main.load_next_map()
	else:
		valid_detector_count -= 1
