extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.change_clip(AudioPlayer.SONGS.FOREST)
	player.global_position = Checkpoint.checkpoint_pos
	$Camera2D.global_position = Checkpoint.checkpoint_pos

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
	AudioPlayer.master_volume = value

func _on_music_value_changed(value: float) -> void:
	AudioPlayer.music_volume = value

func _on_sfx_value_changed(value: float) -> void:
	AudioPlayer.sfx_volume = value

func _on_menu_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	$PauseMenu.hide()
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
	
