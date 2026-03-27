extends State
class_name PlayerIdle

@export var state_name: String = "idle"

# Time needed to hold down to look down
@export var look_time: float = 0.5
var cur_look: float = 0

func enter():
	character.play_animation("idle")
	character.move_and_slide()

func update(delta: float):
	character.velocity.y += character.gravity
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * delta)
	character.move_and_slide()
	character.global_position = character.global_position.round()
	if character.is_on_floor():
		character.coyote_timer.start()
		character.jump_available = true
		character.air_dash_available = true
	
	if Input.is_action_pressed("move_down"):
		cur_look = clamp(cur_look + delta, 0, 100)
	else:
		cur_look = 0
	
	if cur_look >= look_time:
		character.camera.looking_down = true
	else:
		character.camera.looking_down = false
	
	
	if (Input.get_axis("move_left", "move_right")):
		state_transition.emit(self, "walking")
		return
	if character.jump_buffer_timer.time_left > 0 and character.coyote_timer.time_left > 0.0 and character.jump_available:
		state_transition.emit(self, "jumping")
		return
		
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		state_transition.emit(self, "dashing")
		return
	if !character.is_on_floor() and character.velocity.y > 0.0:
		state_transition.emit(self, "falling")
		return
		
	

		
	
