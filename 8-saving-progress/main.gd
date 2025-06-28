extends Node

const GAME_SAVE_PATH := "user://game.save"
const KEY_MAP_PATH := "map_path"
const GAME_SAVE_VERSION := 1
const KEY_GAME_SAVE_VERSION := "version"
const MAP_PATH_PREFIX := "res://maps/"

var current_map_path: String


func can_continue() -> bool:
	return FileAccess.file_exists(GAME_SAVE_PATH)


func load_continue_map() -> void:
	if not can_continue():
		print("Tried to continue without save file!")
		return
	
	var game_save_file := FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
	var game_save_data := game_save_file.get_var() as Dictionary
	if game_save_data[KEY_GAME_SAVE_VERSION] > GAME_SAVE_VERSION:
		print("Tried to load unknown future save file format!")
		return
	
	var map_path := game_save_data[KEY_MAP_PATH] as String
	if (
			not map_path.begins_with(MAP_PATH_PREFIX)
			or map_path.contains("..")
	):
		print("Invalid map path!")
		return
	load_map(map_path)


func load_next_map() -> void:
	var split_path := current_map_path.split(".")
	var next_map_number := split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path = ".".join(split_path)
	
	if not ResourceLoader.exists(next_map_path):
		split_path[1] = "001"
		next_map_path = ".".join(split_path)
	load_map(next_map_path)


func load_map(map_path: String) -> void:
	ResourceLoader.load_threaded_request(map_path)
	
	get_tree().paused = true
	await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(map_path)
	)
	
	await MapTransition.play_enter_map()
	get_tree().paused = false


func map_loaded(map_path: String) -> void:
	current_map_path = map_path
	
	var game_save_file := FileAccess.open(GAME_SAVE_PATH, FileAccess.WRITE)
	game_save_file.store_var({
		KEY_MAP_PATH: map_path,
		KEY_GAME_SAVE_VERSION: GAME_SAVE_VERSION,
	})
