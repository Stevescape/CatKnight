extends CanvasLayer

func resume_game():
	get_tree().paused = false
	hide()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	
func pause_game():
	get_tree().paused = true
	show()
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == true:
			resume_game()
		else:
			pause_game()
