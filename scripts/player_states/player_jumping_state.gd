extends State
class_name PlayerJumpingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "jumping"

var horizontal_velocity: float = 0 # store momentum from walking
func enter():
	horizontal_velocity = character.velocity.x
	character.velocity.y = character.jump_velocity
	#sprite.animation = "jump"
	print("jump")     
	
func update(delta: float):
	# gravity
	character.velocity.y += character.gravity
	# horizontal movement
	var input_x = Input.get_axis("move_left", "move_right")
	
	if input_x != 0: 
		horizontal_velocity = input_x * character.speed * 0.8
	character.velocity.x = horizontal_velocity
	
	character.move_and_slide() 
	
	# air dash
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		print("pressed dash")
		state_transition.emit(self, "dashing")
	
	if character.is_on_floor():
		character.air_dash_available = true
		if input_x == 0:
			state_transition.emit(self, "idle")
		else:
			state_transition.emit(self, "walking")
