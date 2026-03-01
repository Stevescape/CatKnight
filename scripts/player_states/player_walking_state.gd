extends State
class_name PlayerWalkingState

@export var speed: float = 15 
@export var state_name: String = "walking"

func enter():
	if character.anim_sprite != null:
		character.anim_sprite.play("walk")

func update(delta: float):
	if character.is_on_floor():
		character.coyote_timer.start()
		
	var dir = Input.get_axis("move_left", "move_right")
	if character.velocity.x == 0 and dir == 0:
		state_transition.emit(self, "idle")
		return
	
	character.velocity.x = move_toward(character.velocity.x, dir * character.speed, character.acceleration * delta)
	character.velocity.y += character.gravity
	#print(player.velocity)
	character.move_and_slide()
	character.global_position = character.global_position.round()
	
	if !character.is_on_floor() and character.velocity.y > 0:
		state_transition.emit(self, "falling")
		return
		
	if Input.is_action_just_pressed("pounce") and character.air_dash_available:
		state_transition.emit(self, "dashing")
		return
	
	if Input.is_action_just_pressed("jump") and character.coyote_timer.time_left > 0.0:
		state_transition.emit(self, "jumping")
		return
	
	
	
	
