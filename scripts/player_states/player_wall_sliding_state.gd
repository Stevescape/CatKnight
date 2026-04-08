extends State
class_name PlayerWallSlidingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "wall sliding"

func enter():
	#character.play_animation("slide")
	#character.spawn_dust()
	character.current_wall_slide_speed = character.wall_slide_start_speed
	

func update(delta: float):
	var input_x = Input.get_axis("move_left", "move_right")
	
	# Check if on wall
	if character.is_touching_wall() and character.is_moving_towards_wall():
		character.wall_slide_timer.start()

	# Grace period for being off wall
	if character.wall_slide_timer.time_left == 0:
		print("fall?")
		state_transition.emit(self, "falling")
		return
	
	if input_x == 0:
		state_transition.emit(self, "falling")
		return
	
	character.current_wall_slide_speed = min(
		character.current_wall_slide_speed + character.wall_slide_acceleration * delta,
		character.wall_slide_speed
	)

	character.velocity.y += character.gravity
	character.velocity.y = min(character.velocity.y, character.current_wall_slide_speed)

	if character.is_on_floor():
		state_transition.emit(self, "idle")
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
		state_transition.emit(self, "wall jumping")
		return
		
	# Pounce off of wall
	if Input.is_action_just_pressed("pounce"):
		state_transition.emit(self, "dashing")
		return

	character.move_and_slide()
