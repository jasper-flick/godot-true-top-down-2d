extends CanvasLayer

var root_window : Window


func activate() -> void:
	root_window.add_child(self)
	get_tree().paused = true
	Engine.time_scale = 0.0


func _close_pause_menu() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	root_window.remove_child(self)


func _ready() -> void:
	root_window = get_tree().root
	root_window.remove_child.call_deferred(self)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_close_pause_menu()


func _on_resume_button_pressed() -> void:
	_close_pause_menu()


func _on_restart_button_pressed() -> void:
	_close_pause_menu()
	Main.restart_map()
