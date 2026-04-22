extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	%TimerLabel.text = "Time: " + SpeedrunTimer.get_time_string()

func _on_main_menu_pressed() -> void:
	SceneTransition.change_scene("res://scenes/main_menu.tscn")


func _on_retry_pressed() -> void:
	SceneTransition.change_scene("res://scenes/level_1.tscn")
