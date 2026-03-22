extends CharacterBody2D
class_name Enemy

# movement
@export var patrol_speed: float = 40.0
@export var chase_speed: float = 75.0
@export var acceleration: float = 12.0

# gravity
@export var gravity: float = 900.0

# detection / combat
@export var detection_range: float = 180.0
@export var attack_range: float = 30.0
@export var attack_damage: int = 1
@export var attack_cooldown: float = 1.0

# patrol
@export var patrol_points: Array[Node2D] = []
var current_patrol_index: int = 0

# health system
@export var max_health: int = 3
var current_health: float

# damage knockback
@export var knockback_duration: float = 0.2
@export var knockback_power: Vector2 = Vector2(250, -120)
var knockback_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

# references
@onready var sm: Node = $StateMachine
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# player reference
var player: Node2D = null

# attack timer
var attack_timer: float = 0.0

# sprite direction
enum Direction { LEFT = -1, RIGHT = 1 }

var direction_suffix = {
	Direction.LEFT: "_left",
	Direction.RIGHT: "_right"
}

var last_direction: Direction = Direction.RIGHT

func _ready():
	current_health = max_health
	find_player()

	if patrol_points.is_empty() and has_node("Waypoints"):
		for child in $Waypoints.get_children():
			if child is Node2D:
				patrol_points.append(child)


func _physics_process(delta: float) -> void:
	find_player()

	if attack_timer > 0:
		attack_timer -= delta


func find_player():
	if get_tree().get_first_node_in_group("player") != null:
		player = get_tree().get_first_node_in_group("player")


func anim_suffix():
	return direction_suffix[last_direction]


func play_animation(name: String):
	if anim_sprite != null:
		anim_sprite.play(name + anim_suffix())


func refresh_anim():
	if anim_sprite != null:
		var anim = anim_sprite.animation.trim_suffix("_left").trim_suffix("_right")
		var frame = anim_sprite.frame
		var was_playing = anim_sprite.is_playing()

		play_animation(anim)
		anim_sprite.frame = frame

		if not was_playing:
			anim_sprite.stop()


func face_direction(dir: float):
	if dir > 0 and last_direction != Direction.RIGHT:
		last_direction = Direction.RIGHT
		refresh_anim()
	elif dir < 0 and last_direction != Direction.LEFT:
		last_direction = Direction.LEFT
		refresh_anim()


func can_see_player() -> bool:
	if player == null:
		return false

	return global_position.distance_to(player.global_position) <= detection_range


func in_attack_range() -> bool:
	if player == null:
		return false

	return global_position.distance_to(player.global_position) <= attack_range


func get_patrol_target() -> Node2D:
	if patrol_points.is_empty():
		return null
	return patrol_points[current_patrol_index]


func advance_patrol_point():
	if patrol_points.is_empty():
		return

	current_patrol_index += 1
	if current_patrol_index >= patrol_points.size():
		current_patrol_index = 0


func attack():
	if player == null:
		return

	if attack_timer > 0:
		return

	attack_timer = attack_cooldown

	if player.has_method("take_damage") and in_attack_range():
		var attack_direction = 1
		if player.global_position.x < global_position.x:
			attack_direction = -1

		player.take_damage(attack_damage, attack_direction)


func take_damage(amount: float, attack_direction: int):
	current_health -= amount
	current_health = max(current_health, 0)

	knockback_timer = knockback_duration
	knockback_velocity = Vector2(knockback_power.x * attack_direction, knockback_power.y)

	if current_health <= 0:
		die()
		return

	sm.force_change_state("damaged")


func die():
	queue_free()
