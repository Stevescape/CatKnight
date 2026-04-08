extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioPlayer.change_clip(AudioPlayer.SONGS.TITLE)


func _on_start_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	SceneTransition.change_scene("res://scenes/level_1.tscn")
	


func _on_quit_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	get_tree().quit()


func _on_back_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	$main_buttons.show()
	$options_menu.hide()

func _on_option_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	$main_buttons.hide()
	$options_menu.show()

func _on_volume_value_changed(value: float) -> void:
	AudioPlayer.master_volume = value

func _on_music_value_changed(value: float) -> void:
	AudioPlayer.music_volume = value

func _on_sfx_value_changed(value: float) -> void:
	AudioPlayer.sfx_volume = value
