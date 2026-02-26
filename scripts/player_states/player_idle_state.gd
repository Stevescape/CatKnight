extends State
class_name PlayerIdle

@export var sprite: AnimatedSprite2D
@export var state_name: String = "idle"

func update(delta: float):
	if character.is_on_floor():
		character.coyote_timer.start()
	
	if (Input.get_axis("move_left", "move_right")):
		state_transition.emit(self, "walking")
		print("walking")
		return
	elif Input.is_action_just_pressed("jump") and character.coyote_timer.time_left > 0.0:
		state_transition.emit(self, "jumping")
		return
		
	if !character.is_on_floor() and character.velocity.y > 0.0:
		state_transition.emit(self, "falling")
		return
		
	character.velocity.y += character.gravity
	character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)
	character.move_and_slide()

		
	
