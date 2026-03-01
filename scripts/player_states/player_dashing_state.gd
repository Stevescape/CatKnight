extends State
class_name PlayerAirDashingState

@export var state_name: String = "dashing"

var dash_timer: float = 0.0
var dash_direction: float = 0.0
var dash_vector: Vector2 = Vector2.ZERO

func enter():
	print("dashing")
	character.play_animation("pounce")
	character.spawn_dust()
	
	var input_x = Input.get_axis("move_left", "move_right")
	
	if input_x == 0 and character.velocity.x != 0:
		input_x = 1 if character.velocity.x > 0 else -1

	if input_x != 0:
		dash_direction = input_x
	elif character.velocity.x != 0:
		dash_direction = 1 if character.velocity.x > 0 else -1
	else:
		dash_direction = character.last_direction
		
	character.air_dash_available = false
	dash_timer = character.air_dash_duration
	character.velocity.y = -250
	character.velocity.x = dash_direction * character.air_dash_speed
	
		
func update(delta: float):
	dash_timer -= delta
	character.velocity.x = dash_direction * character.air_dash_speed
	character.velocity.y += character.gravity
	character.move_and_slide()
	character.global_position = character.global_position.round()
	
	if character.is_on_floor():
		if character.velocity.x == 0:
			state_transition.emit(self, "idle")
		else:
			state_transition.emit(self, "walking")
		character.spawn_dust()
		character.shake_camera()
		return
	
	if dash_timer <= 0:
		state_transition.emit(self, "falling")
				
func exit():
	character.air_dash_available = true
