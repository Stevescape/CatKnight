extends State
class_name PlayerJumpingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "jumping"

var horizontal_velocity: float = 0 # store momentum from walking
func enter():
	horizontal_velocity = character.velocity.x * 0.4
	character.velocity.y = character.jump_velocity
	character.coyote_timer.stop()
	print("jump")     
	
func update(delta: float):
	# different types of jumps
	if character.velocity.y < 0 and not Input.is_action_pressed("jump"):
		# released early → short jump
		print("min jump")
		character.velocity.y += character.gravity * character.jump_cut_multiplier
	else:
		# space held → long jump
		print("normal jump")
		character.velocity.y += character.gravity
	
	# horizontal movement
	var input_x = Input.get_axis("move_left", "move_right")

	var temp := 0.0
	# Lose original horizontal momentum overtime
	if horizontal_velocity != 0:
		temp += horizontal_velocity
		horizontal_velocity = lerp(horizontal_velocity, 0.0, 0.1)
		
	if input_x != 0: 
		temp += input_x * character.speed * 0.6
	
	character.velocity.x = temp
	
	character.move_and_slide() 
	
	# air dash
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		print("pressed dash")
		state_transition.emit(self, "dashing")
		return
	
	if character.is_on_floor():
		character.air_dash_available = true
		if input_x == 0:
			state_transition.emit(self, "idle")
			return
		else:
			state_transition.emit(self, "walking")
			return
			
	if !character.is_on_floor() and character.velocity.y > 0:
		state_transition.emit(self, "falling")
		return
