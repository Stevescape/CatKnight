extends State



func enter():
	character.set_collision_layer_value(4, false)
	if character.anim_player != null:
		character.anim_player.play("cooldown")
	var timer = get_tree().create_timer(character.cooldown)
	timer.connect("timeout", func():
		state_transition.emit(self, "idle")
	)
