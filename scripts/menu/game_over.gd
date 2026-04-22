extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioPlayer.change_clip(AudioPlayer.SONGS.GAME_OVER)

func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/main_menu.tscn")


func _on_retry_pressed() -> void:
	SceneTransition.change_scene("res://scenes/level_1.tscn")
