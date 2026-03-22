extends State
class_name EnemyChaseState

@export var state_name: String = "chase"

func enter():
	character.play_animation("walk")

func update(delta: float):
	if character.player == null:
		state_transition.emit(self, "patrol")
		return

	if not character.can_see_player():
		state_transition.emit(self, "patrol")
		return

	if character.in_attack_range():
		state_transition.emit(self, "attack")
		return

	var dir = sign(character.player.global_position.x - character.global_position.x)
	character.face_direction(dir)

	character.velocity.x = move_toward(
		character.velocity.x,
		dir * character.chase_speed,
		character.acceleration
	)

	character.velocity.y += character.gravity * delta
	character.move_and_slide()
