class_name GameMap
extends Node

const KEY_BEST_TIME := "best_time"
const KEY_BEST_TRAVEL_DISTANCE := "best_travel_distance"

@export var map_name := "Map"

var player_character: PlayerCharacter
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
		else:
			var pc := child_node as PlayerCharacter
			if pc:
				player_character = pc
	
	Main.map_loaded(self)
	HUD.show_map_info(self)
	HUD.show_map_detector_count(
			valid_detector_count, registered_detector_count
	)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detector_count += 1
		if valid_detector_count == registered_detector_count:
			_update_best_scores()
			Main.load_next_map()
	else:
		valid_detector_count -= 1
	
	HUD.show_map_detector_count(
			valid_detector_count, registered_detector_count
	)


func _update_best_scores() -> void:
	var new_time := floori(current_map_time)
	if (
			not map_save_data.has(KEY_BEST_TIME)
			or new_time < map_save_data[KEY_BEST_TIME]
	):
		map_save_data[KEY_BEST_TIME] = new_time
	else:
		new_time = -1
	
	var new_travel_distance := floori(player_character.travel_distance)
	if (
			not map_save_data.has(KEY_BEST_TRAVEL_DISTANCE)
			or new_travel_distance < map_save_data[KEY_BEST_TRAVEL_DISTANCE]
	):
		map_save_data[KEY_BEST_TRAVEL_DISTANCE] = new_travel_distance
	else:
		new_travel_distance = -1
	
	HUD.show_new_best_map_scores(new_time, new_travel_distance)
