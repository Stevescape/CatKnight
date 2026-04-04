extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/level_1.tscn")
