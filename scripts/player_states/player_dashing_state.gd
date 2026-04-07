extends State
class_name PlayerAirDashingState

@export var state_name: String = "dashing"

var dash_timer: float = 0.0
var dash_direction: float = 0.0
var dash_vector: Vector2 = Vector2.ZERO
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
		
	
	
	var input_x = Input.get_axis("move_left", "move_right")
	
	if input_x == 0 and character.velocity.x != 0:
		input_x = 1 if character.velocity.x > 0 else -1

	if input_x != 0:
		dash_direction = input_x
	elif character.velocity.x != 0:
		dash_direction = 1 if character.velocity.x > 0 else -1
	else:
		dash_direction = character.last_direction
		
	if character.is_on_wall() and character.last_wall_normal != Vector2.ZERO:
		dash_direction = 1 if character.last_wall_normal.x > 0 else -1
	
	character.air_dash_available = false
	dash_timer = character.air_dash_duration
	character.velocity.y = -250
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
	
	if character.is_on_wall() and not character.is_on_floor():
		var collision = character.get_last_slide_collision()
		
		if collision and not collision.get_collider().is_in_group("pounceable"):
			character.last_wall_normal = character.get_wall_normal()
		
			if character.velocity.y < 0:
				character.velocity.y = 0
			state_transition.emit(self, "wall sliding")
			return
		
		
	
	if collide_pounceable_node():
		character.air_dash_available = true
		state_transition.emit(self, "falling")
		return
	
	if character.is_on_floor():
		if character.velocity.x == 0:
			state_transition.emit(self, "idle")
		else:
			state_transition.emit(self, "walking")
		character.spawn_dust()
		character.shake_camera(character.landing_screenshake)
		return
	
	if character.jump_buffer_timer.time_left > 0 and character.jump_available:
		state_transition.emit(self, "jumping")
		return
	
	if dash_timer <= 0:
		state_transition.emit(self, "falling")
				
func exit():
	allow_p_jump = false
	character.set_collision_mask_value(4, false)
