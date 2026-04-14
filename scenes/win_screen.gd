extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_start_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	SceneTransition.change_scene("res://scenes/main_menu.tscn")


func _on_retry_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	SceneTransition.change_scene("res://scenes/level_1.tscn")
