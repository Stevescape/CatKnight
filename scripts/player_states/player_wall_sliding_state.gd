extends State
class_name PlayerWallSlidingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "wall sliding"

#func enter():
	#character.play_animation("slide")
	#character.spawn_dust()

func update(delta: float):
	var input_x = Input.get_axis("move_left", "move_right")

	if character.is_on_floor():
		state_transition.emit(self, "idle")
		return

	if not character.is_on_wall():
		state_transition.emit(self, "falling")
		return

	var wall_normal = character.get_wall_normal()
	character.last_wall_normal = wall_normal

	if wall_normal.x > 0 and input_x > 0:
		character.coyote_timer.start()
		state_transition.emit(self, "falling")
		return

	if wall_normal.x < 0 and input_x < 0:
		character.coyote_timer.start()
		state_transition.emit(self, "falling")
		return

	character.velocity.y = min(character.velocity.y, character.wall_slide_speed)

	if Input.is_action_just_pressed("jump") and character.wall_jump_available:
		if character.last_wall_normal.x > 0 and input_x < 0:
			return
		if character.last_wall_normal.x < 0 and input_x > 0:
			return
		
		character.velocity.y = character.wall_jump_force
		character.velocity.x = character.last_wall_normal.x * character.wall_jump_push
		character.wall_jump_available = false
		state_transition.emit(self, "jumping")
		return

	character.move_and_slide()
