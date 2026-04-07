extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioPlayer.change_clip(AudioPlayer.SONGS.TITLE)

func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/level_1.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$main_buttons.show()
	$options_menu.hide()

func _on_option_pressed() -> void:
	$main_buttons.hide()
	$options_menu.show()


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/$options_menu/volume.max_value))
