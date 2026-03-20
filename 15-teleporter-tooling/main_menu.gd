extends Control

@export var first_map: PackedScene
@export var continue_button: Button


func _ready() -> void:
	if not Main.can_continue():
		continue_button.disabled = true

func _on_new_game_button_pressed() -> void:
	Main.load_map(first_map.resource_path)


func _on_continue_button_pressed() -> void:
	Main.load_continue_map()
