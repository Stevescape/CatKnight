extends State
class_name PlayerWallPounceState
@export var state_name: String = "wall pouncing"
@export var max_bounces: int = 50

var dash_timer: float = 0.0
var dash_direction: float = 0.0
var bounces_remaining: int = 0
var p_jump_time = 0.05
var p_jump_timer
var allow_p_jump = false

func enter():
	character.play_animation("pounce")
	AudioPlayer.play_sfx(AudioPlayer.SFX.DASH)
	character.spawn_dust()
	
	p_jump_timer = get_tree().create_timer(p_jump_time)
	allow_p_jump = true
	p_jump_timer.connect("timeout", func():
		if allow_p_jump:
			character.set_collision_mask_value(4, true)
	)
	
	# Inherit direction from the wall normal so we always launch away from it
	if character.last_wall_normal.x != 0:
		dash_direction = sign(character.last_wall_normal.x)
	else:
		var input_x = Input.get_axis("move_left", "move_right")
		if input_x != 0:
			dash_direction = input_x
		elif character.velocity.x != 0:
			dash_direction = sign(character.velocity.x)
		else:
			dash_direction = character.last_direction

	character.air_dash_available = false
	bounces_remaining = max_bounces
	dash_timer = character.air_dash_duration
	character.velocity.y = -300
	character.velocity.x = dash_direction * character.air_dash_speed

func collide_pounceable_node() -> bool:
	var num = character.get_slide_collision_count()
	for i in range(num):
		var collided = character.get_slide_collision(i).get_collider() as Node2D
		if collided.is_in_group("pounceable"):
			collided.collided.emit(character)
			return true
	return false

func update(delta: float):
	dash_timer -= delta
	character.velocity.x = dash_direction * character.air_dash_speed
	character.velocity.y += character.gravity
	character.move_and_slide()
	character.global_position = character.global_position.round()

	# Wall bounce — the core new behaviour
	if character.is_on_wall() and not character.is_on_floor():
		var collision = character.get_last_slide_collision()
		if collision and not collision.get_collider().is_in_group("pounceable"):
			character.last_wall_normal = character.get_wall_normal()
			if bounces_remaining > 0:
				state_transition.emit(self, "wall hold")
				return
			else:
				# Out of bounces — slide or fall depending on velocity
				if character.velocity.y < 0:
					character.velocity.y = 0
				state_transition.emit(self, "wall sliding")
				return

	if collide_pounceable_node():
		character.air_dash_available = true
		bounces_remaining = max_bounces  # reset so re-entering feels consistent
		state_transition.emit(self, "falling")
		return

	if character.is_on_floor():
		character.spawn_dust()
		character.shake_camera(character.landing_screenshake)
		if character.velocity.x == 0:
			state_transition.emit(self, "idle")
		else:
			state_transition.emit(self, "walking")
		return

	if character.jump_buffer_timer.time_left > 0 and (character.jump_available):
		state_transition.emit(self, "jumping")
		return

	if dash_timer <= 0:
		state_transition.emit(self, "falling")

func exit():
	allow_p_jump = false
	character.set_collision_mask_value(4, false)
