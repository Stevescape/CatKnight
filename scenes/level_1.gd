extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.change_clip(AudioPlayer.SONGS.FOREST)

func resume_game():
	get_tree().paused = false
	$PauseMenu.hide()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	
func pause_game():
	get_tree().paused = true
	$PauseMenu.show()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)





func _on_helmet_pressed() -> void:
	$Player.swap_sprite()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)


func _on_resume_pressed() -> void:
	resume_game()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/$PauseMenu/ColorRect/VBoxContainer/master.max_value))

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value/$PauseMenu/ColorRect/VBoxContainer/master.max_value))

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/$PauseMenu/ColorRect/VBoxContainer/master.max_value))
