extends State

func enter():
	character.set_collision_layer_value(4, true)
	if character.anim_player != null:
		character.anim_player.play_backwards("cooldown")
	
