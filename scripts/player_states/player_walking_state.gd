extends State
class_name PlayerWalkingState

@export var speed: float = 15 
@export var state_name: String = "walking"

func update(delta: float):
	if character.is_on_floor():
		character.coyote_timer = character.coyote_time
	else:
		character.coyote_timer = max(character.coyote_timer - delta, 0.0)
	
	if Input.is_action_just_pressed("jump") and character.coyote_timer > 0.0:
		character.coyote_timer = 0.0
		state_transition.emit(self, "jumping")
		return
	
	var dir = Input.get_axis("move_left", "move_right")
	if dir == 0:
		state_transition.emit(self, "idle")
	
	if !character.is_on_floor() and character.velocity.y > 0:
		state_transition.emit(self, "falling")
		
	character.velocity.x = lerp(character.velocity.x, dir * character.speed, 0.7)
	character.velocity.y += character.gravity
	#print(player.velocity)
	character.move_and_slide()
	
