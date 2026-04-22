extends Control

var dialogue = preload("res://dialogue/cutscene/letter.dialogue")
@onready var anim_player = $AnimationPlayer
var bubble = preload("res://dialogue/default_balloon.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioPlayer.change_clip(AudioPlayer.SONGS.TITLE)
	$background.animation_finished.connect(play_cloud_background)
	AudioPlayer.volume_db = 0

func play_game_scene():
	SceneTransition.change_scene("res://scenes/cutscene.tscn")

func _on_start_pressed() -> void:
	$background.play("paper_pan")
	anim_player.play_backwards("menu")
	await get_tree().create_timer(1.5).timeout
	DialogueManager.show_dialogue_balloon_scene(bubble, dialogue, "start")
	AudioPlayer.play_sfx(AudioPlayer.SFX.PAPER)
	await DialogueManager.dialogue_ended
	play_game_scene()
	
func play_cloud_background():
	if $background.animation == "pan":
		$background.play("cloud")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	%main_buttons.show()
	$options_menu.hide()

func _on_option_pressed() -> void:
	%main_buttons.hide()
	$options_menu.show()

func _on_volume_value_changed(value: float) -> void:
	AudioPlayer.master_volume = value

func _on_music_value_changed(value: float) -> void:
	AudioPlayer.music_volume = value

func _on_sfx_value_changed(value: float) -> void:
	AudioPlayer.sfx_volume = value

func _on_skip_pressed() -> void:
	SceneTransition.change_scene("res://scenes/level_1.tscn")
