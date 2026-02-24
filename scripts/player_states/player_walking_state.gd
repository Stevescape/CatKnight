extends State
class_name PlayerWalkingState

@export var player: CharacterBody2D
@export var speed: float = 15 
func update(delta: float):
	var dir = Input.get_axis("move_left", "move_right")
	if dir == 0:
		state_transition.emit(self, "idle")
	
	var movement_vector = Vector2(dir, 0)
	player.velocity = movement_vector * speed
	print(player.velocity)
	player.move_and_slide()
	
func exit():
	player.velocity = Vector2(0, 0)
