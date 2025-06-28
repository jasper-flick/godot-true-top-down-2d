extends Node

@export var animation_player : AnimationPlayer

var root_window : Window


func _ready() -> void:
	root_window = get_tree().root
	root_window.remove_child.call_deferred(self)


func play_exit_map() -> void:
	root_window.add_child(self)
	animation_player.play("exit_map")
	await animation_player.animation_finished


func play_enter_map() -> void:
	animation_player.play("enter_map")
	await animation_player.animation_finished
	root_window.remove_child(self)
