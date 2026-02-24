extends State
class_name PlayerIdle

@export var sprite: AnimatedSprite2D

func enter():
	pass

func update(delta: float):
	if (Input.get_axis("move_left", "move_right")):
		state_transition.emit(self, "walking")
