extends State
class_name PlayerHurtState



@export var state_name: String = "hurting"
@export var sprite: AnimatedSprite2D # later implmementation

var timer: float

func enter():
	# knockback
	print("hurt state")
	
func update(delta):
	if character.knockback_timer > 0:
		character.knockback_timer -= delta

		# Apply gravity to Y velocity for arched movement
		character.knockback_velocity.y += character.gravity

		# Set current velocity
		character.velocity = character.knockback_velocity
		character.move_and_slide()

		return  # skip normal movement during knockback

	# After knockback ends, return to normal states
	if character.is_on_floor():
		if Input.get_axis("move_left", "move_right") != 0:
			state_transition.emit(self, "walking")
		else:
			state_transition.emit(self, "idle")
	else:
		state_transition.emit(self, "falling")
	
