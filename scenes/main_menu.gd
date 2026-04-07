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
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/$options_menu/master.max_value))


func _on_music_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value/$options_menu/music.max_value))

func _on_sfx_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/$options_menu/sfx.max_value))
