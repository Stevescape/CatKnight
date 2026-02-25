extends State
class_name PlayerWalkingState

@export var speed: float = 15 
@export var state_name: String = "walking"

func update(delta: float):
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		state_transition.emit(self, "jumping")
		return
	
	var dir = Input.get_axis("move_left", "move_right")
	if dir == 0:
		state_transition.emit(self, "idle")
	
	character.velocity.x = lerp(character.velocity.x, dir * character.speed, 0.7)
	character.velocity.y += character.gravity
	#print(player.velocity)
	character.move_and_slide()
	
