extends State
class_name PlayerIdle

@export var state_name: String = "idle"

func enter():
	character.play_animation("idle")

func update(delta: float):
	character.velocity.y += character.gravity
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * delta)
	character.move_and_slide()
	character.global_position = character.global_position.round()
	if character.is_on_floor():
		character.coyote_timer.start()
	
	if (Input.get_axis("move_left", "move_right")):
		state_transition.emit(self, "walking")
		print("walking")
		return
	if Input.is_action_just_pressed("jump") and character.coyote_timer.time_left > 0.0:
		state_transition.emit(self, "jumping")
		return
		
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		state_transition.emit(self, "dashing")
		return
	if !character.is_on_floor() and character.velocity.y > 0.0:
		state_transition.emit(self, "falling")
		return
		
	

		
	
