extends State
class_name EnemyAttackState

@export var state_name: String = "attacking"
@export var attack_duration: float = 0.35

var timer: float = 0.0
var has_attacked: bool = false

func enter():
	timer = attack_duration
	has_attacked = false
	character.velocity.x = 0
	#character.play_animation("attack")
	print("Enemy is attacking")

func update(delta: float):
	if character.player == null:
		state_transition.emit(self, "patrolling")
		return

	if not character.in_attack_range():
		state_transition.emit(self, "chasing")
		return

	var dir = sign(character.player.global_position.x - character.global_position.x)
	character.face_direction(dir)

	character.velocity.x = 0
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

	if not has_attacked:
		character.attack()
		has_attacked = true

	timer -= delta

	if timer <= 0:
		if character.in_attack_range():
			state_transition.emit(self, "attacking")
		else:
			state_transition.emit(self, "chasing")
