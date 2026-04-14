extends State
class_name PlayerDeath

@onready var fade_anim_player: AnimationPlayer = get_tree().current_scene.get_node("CanvasLayer/AnimationPlayer")
@onready var hearts_ui: CanvasLayer = get_tree().current_scene.get_node("CanvasLayer")

var debounce = false

func enter():
	debounce = false
	AudioPlayer.play_sfx(AudioPlayer.SFX.DEATH)
	
func update(delta):
	if debounce:
		return
	debounce = true

	fade_anim_player.play("fade")
	await fade_anim_player.animation_finished

	character.lives -= 1
	hearts_ui.update_hearts(character.lives)
	print("Player has lost a life")
	print(character.lives)

	if character.lives <= 0:
		print("Calling game over scene change")
		Checkpoint.checkpoint_pos = Checkpoint.inital_checkpoint
		SceneTransition.change_scene("res://scenes/game_over.tscn")
		return

	character.global_position = Checkpoint.checkpoint_pos
	character.camera.global_position = Checkpoint.checkpoint_pos

	print("Swapping to idle")
	state_transition.emit(self, "idle")

func exit():
	if character.lives > 0:
		fade_anim_player.play_backwards("fade")
