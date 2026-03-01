extends State
class_name PlayerJumpingState

@export var sprite: AnimatedSprite2D
@export var state_name: String = "jumping"
@export var min_jump_duration: float = 0.1

# If jump is held shorter than this, default to this
var min_jump_timer: Timer

var horizontal_velocity: float = 0 # store momentum from walking

func _ready():
	min_jump_timer = Timer.new()
	add_child(min_jump_timer)
	min_jump_timer.wait_time = min_jump_duration
	min_jump_timer.one_shot = true

func enter():
	var player_script = character as Player
	if player_script.anim_sprite != null:
		player_script.anim_sprite.play("jump")
	character.spawn_dust()
	horizontal_velocity = character.velocity.x * 0.4
	character.velocity.y = character.jump_velocity
	character.coyote_timer.stop()
	min_jump_timer.start()
	
func update(delta: float):
	# different types of jumps
	if character.velocity.y < 0 and not Input.is_action_pressed("jump") and min_jump_timer.time_left <= 0:
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
		horizontal_velocity = move_toward(horizontal_velocity, 0.0, character.acceleration * delta)
		
	if input_x != 0: 
		temp += input_x * character.speed * 0.6
	
	character.velocity.x = temp
	
	character.move_and_slide() 
	character.global_position.x = round(character.global_position.x)
	# air dash
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
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
