extends Node


func load_next_map() -> void:
	var current_map_path := get_tree().current_scene.scene_file_path
	var split_path := current_map_path.split(".")
	var next_map_number := split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path = ".".join(split_path)
	
	if not ResourceLoader.exists(next_map_path):
		split_path[1] = "001"
		next_map_path = ".".join(split_path)
	
	ResourceLoader.load_threaded_request(next_map_path)
	
	get_tree().paused = true
	await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(next_map_path)
	)
	
	await MapTransition.play_enter_map()
	get_tree().paused = false
