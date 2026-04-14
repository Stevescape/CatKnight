extends Control

var dialogue = preload("res://dialogue/cutscene/letter.dialogue")
@onready var anim_player = $AnimationPlayer
var bubble = preload("res://dialogue/default_balloon.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioPlayer.change_clip(AudioPlayer.SONGS.TITLE)
	$background.animation_finished.connect(play_cloud_background)
	AudioPlayer.change_clip(AudioPlayer.SONGS.THRONE)

func play_game_scene():
	SceneTransition.change_scene("res://scenes/cutscene.tscn")

func _on_start_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	DialogueManager.show_dialogue_balloon_scene(bubble, dialogue, "start")
	await DialogueManager.dialogue_ended
	play_game_scene()
	
func play_cloud_background():
	$background.play("cloud")

func _on_quit_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	get_tree().quit()


func _on_back_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	%main_buttons.show()
	$options_menu.hide()

func _on_option_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	%main_buttons.hide()
	$options_menu.show()

func _on_volume_value_changed(value: float) -> void:
	AudioPlayer.master_volume = value

func _on_music_value_changed(value: float) -> void:
	AudioPlayer.music_volume = value

func _on_sfx_value_changed(value: float) -> void:
	AudioPlayer.sfx_volume = value

func _on_skip_pressed() -> void:
	AudioPlayer.play_sfx(AudioPlayer.SFX.OPTIONSFX)
	SceneTransition.change_scene("res://scenes/level_1.tscn")
