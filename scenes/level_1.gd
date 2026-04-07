extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.change_clip(AudioPlayer.SONGS.FOREST)

func resume_game():
	get_tree().paused = false
	$PauseMenu.hide()
	
func pause_game():
	get_tree().paused = true
	$PauseMenu.show()


func _on_volume_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/$PauseMenu/ColorRect/VBoxContainer/volume.max_value))


func _on_helmet_pressed() -> void:
	$Player.swap_sprite()


func _on_resume_pressed() -> void:
	resume_game()
