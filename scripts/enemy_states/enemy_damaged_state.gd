extends State
class_name EnemyDamagedState

@export var state_name: String = "damaged"

func enter():
	character.play_animation("hurt")

func update(delta: float):
	character.knockback_timer -= delta

	character.velocity = character.knockback_velocity
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

	character.knockback_velocity.x = move_toward(character.knockback_velocity.x, 0, 25)

	if character.knockback_timer <= 0:
		if character.can_see_player():
			state_transition.emit(self, "chase")
		else:
			state_transition.emit(self, "patrol")
