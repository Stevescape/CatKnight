extends State
class_name EnemyPatrolState

@export var state_name: String = "patrol"
@export var waypoint_tolerance: float = 5.0
@export var wait_time: float = 0.5

var wait_timer: float = 0.0
var waiting: bool = false

func enter():
	waiting = false
	wait_timer = 0.0
	character.play_animation("walk")

func update(delta: float):
	if character.can_see_player():
		state_transition.emit(self, "chase")
		return

	if character.patrol_points.is_empty():
		character.velocity.x = 0
		character.velocity.y += character.gravity * delta
		character.move_and_slide()
		return

	var target_waypoint = character.patrol_points[character.current_patrol_index]

	if target_waypoint == null:
		return

	var distance_x = target_waypoint.global_position.x - character.global_position.x

	if waiting:
		character.velocity.x = 0
		character.velocity.y += character.gravity * delta
		character.move_and_slide()

		wait_timer -= delta
		if wait_timer <= 0:
			waiting = false
			character.current_patrol_index += 1
			if character.current_patrol_index >= character.patrol_points.size():
				character.current_patrol_index = 0
		return

	if abs(distance_x) <= waypoint_tolerance:
		waiting = true
		wait_timer = wait_time
		character.velocity.x = 0
		character.play_animation("idle")
	else:
		var dir = sign(distance_x)
		character.face_direction(dir)
		character.play_animation("walk")

		character.velocity.x = move_toward(
			character.velocity.x,
			dir * character.patrol_speed,
			character.acceleration
		)

	character.velocity.y += character.gravity * delta
	character.move_and_slide()
