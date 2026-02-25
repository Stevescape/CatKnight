extends State
class_name PlayerIdle

@export var sprite: AnimatedSprite2D
@export var state_name: String = "idle"

func update(delta: float):
	if (Input.get_axis("move_left", "move_right")):
		state_transition.emit(self, "walking")
		print("walking")
	elif Input.is_action_just_pressed("jump"):
		state_transition.emit(self, "jumping")
		
	character.velocity.y += character.gravity
	character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)
	character.move_and_slide()
