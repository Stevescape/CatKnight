extends State
class_name PlayerDeath

@onready var fade_anim_player: AnimationPlayer = get_tree().current_scene.get_node("CanvasLayer/AnimationPlayer")
var debounce = false

func enter():
	debounce = false
		
func update(delta):
	# Await animation finished
	# Fade to black
	# Fade back in
	# Await Fade back in
	# Transition to idle
	
	# Prevent being called multiple times while animation plays out
	if debounce:
		return
	debounce = true
	
	# Fade black in
	fade_anim_player.play_backwards("fade")
	await fade_anim_player.animation_finished
	
	# Move character
	character.global_position = Checkpoint.checkpoint_pos
	character.camera.global_position = Checkpoint.checkpoint_pos
	
	print("Swapping to idle")
	state_transition.emit(self, "idle")
	
	
	# Transition to idle
	
	
func exit():
	fade_anim_player.play("fade")
	
	
	
	
	
