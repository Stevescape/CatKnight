extends State
class_name PlayerWallHoldState


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	character.wall_hold_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	if character.wall_hold_timer.time_left <= 0:
		state_transition.emit(self, "falling")
	
	if Input.is_action_just_pressed("pounce"):
		state_transition.emit(self, "wall pounce")
		
	if Input.is_action_just_pressed("jump") and character.wall_jump_available:
		state_transition.emit(self, "wall jumping")
	
