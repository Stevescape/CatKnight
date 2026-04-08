extends State
class_name PlayerFallingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "falling"

var horizontal_velocity: float = 0.0

func enter():
	# keep whatever sideways momentum we had when we started falling
	character.play_animation("fall")
	horizontal_velocity = character.velocity.x

func update(delta: float):
	# gravity
	character.velocity.y += character.gravity
	
	if Input.is_action_just_pressed("jump") and character.coyote_timer.time_left > 0 and character.last_wall_normal != Vector2.ZERO and character.wall_jump_available:
		character.velocity.y = character.wall_jump_force
		character.velocity.x = character.last_wall_normal.x * character.wall_jump_push
		character.wall_jump_available = false
		state_transition.emit(self, "jumping")
		return
	
	# Want to be able to jump while falling if coyote timer is available
	if character.jump_buffer_timer.time_left > 0 and character.coyote_timer.time_left > 0.0 and character.jump_available:
		state_transition.emit(self, "jumping")
		return
	
	# horizontal movement (air control)
	var input_x = Input.get_axis("move_left", "move_right")
	if input_x != 0:
		horizontal_velocity = input_x * character.speed * 0.6
	character.velocity.x = horizontal_velocity

	character.move_and_slide()
	character.global_position = character.global_position.round()
	# air dash / pounce
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		state_transition.emit(self, "dashing")
		return
	
	# wall sliding
	if character.is_touching_wall() and character.is_moving_towards_wall() and not character.is_on_floor() and character.velocity.y > 0:
		state_transition.emit(self, "wall sliding")
		return

	# landed
	if character.is_on_floor():
		character.spawn_dust()
		character.shake_camera(character.landing_screenshake)
		AudioPlayer.play_sfx(AudioPlayer.SFX.LAND)
		character.air_dash_available = true
		character.wall_jump_available = true
		if input_x == 0:
			state_transition.emit(self, "idle")
		else:
			state_transition.emit(self, "walking")
		return
