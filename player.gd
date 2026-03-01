extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 250.0
@export var max_jump_height: float = 100
@export var time_to_reach_peak: float = 0.4

var acceleration: float = speed * 20
var jump_available: bool = true # resets on landing
var min_jump_duration: float = 0.2

# air dash
@export var air_dash_speed: float = 375.0
@export var air_dash_duration: float = 1
var air_dash_available: bool = true # resets on landing

@export var coyote_time: float = 0.15
var coyote_timer: Timer

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0

# DO NOT EDIT THESE -450.0 | 18.75
# THEY ARE CALCULATED FROM TIME_TO_REACH_PEAK AND MAX_JUMP_HEIGHT
var jump_velocity: float = 0
var gravity: float = 0

# jump settings
@export var jump_cut_multiplier = 5
@export var fall_gravity_multiplier = 10
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dust = preload("res://resources/Dust.tscn")
@onready var camera = get_tree().root.get_child(0).get_node("Camera2D")
@onready var dropdown: RayCast2D = $DropDownDetector

var sprites: Array = [
	preload("res://sprites/helmetless.tres"),
	preload("res://sprites/helmet.tres")
]

enum Direction { LEFT= -1, RIGHT=1 }

var direction_suffix = {
	Direction.LEFT: "_left",
	Direction.RIGHT: "_right"
}
var last_direction: Direction = Direction.RIGHT

# 0 is helmetless
# 1 is helmet
var cur_sprite: int = 0:
	set(value):
		cur_sprite = value
		
		# Save current animation info
		var anim = anim_sprite.animation
		var frame = anim_sprite.frame
		var was_playing = anim_sprite.is_playing()
		
		# Update sprite frames
		anim_sprite.sprite_frames = sprites[cur_sprite]
		
		# Restore animation
		anim_sprite.play(anim)
		anim_sprite.frame = frame
		
		if not was_playing:
			anim_sprite.stop()

func _calculate_initial_velocity():
	jump_velocity = (-2 * max_jump_height)/(time_to_reach_peak)

func _calculate_gravity():
	gravity = (2 * max_jump_height)/pow(time_to_reach_peak, 2)
	gravity = gravity/60

func spawn_dust():
	var obj = dust.instantiate()
	get_tree().root.add_child(obj)
	obj.global_position = global_position
	
func anim_suffix():
	return direction_suffix[last_direction]

func play_animation(name: String):
	if anim_sprite != null:
		anim_sprite.play(name + anim_suffix())

func shake_camera():
	if camera != null:
		camera.shake_camera()

func _ready():
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	_calculate_gravity()
	_calculate_initial_velocity()
	print(jump_velocity)
	print(gravity)
	
func start_coyote_timer():
	coyote_timer.start()
	
func refresh_anim():
	if anim_sprite != null:
		# Save current animation info
		var anim = anim_sprite.animation.trim_suffix("_left").trim_suffix("_right")
		var frame = anim_sprite.frame
		var was_playing = anim_sprite.is_playing()	
		
		# Restore animation
		play_animation(anim)
		anim_sprite.frame = frame
		
		if not was_playing:
			anim_sprite.stop()
			
func on_dropdown_platform()-> bool:
	if not dropdown.is_colliding():
		return false
	return true
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if cur_sprite == 0:
			cur_sprite = 1
		else:
			cur_sprite = 0
			
	
	if Input.is_action_just_pressed("move_down") and on_dropdown_platform():
		velocity.y += 50
	
	if Input.is_action_just_pressed("k"):
		if min_jump_duration == 0.2:
			min_jump_duration = 10
		else:
			min_jump_duration = 0.2
		
	if Input.is_action_pressed("move_down"):
		set_collision_mask_value(5, false)
	else:
		set_collision_mask_value(5, true)
	if Input.is_action_just_pressed("move_right"):
		last_direction = Direction.RIGHT
		refresh_anim()
	elif Input.is_action_just_pressed("move_left"):
		last_direction = Direction.LEFT
		refresh_anim()
		
	
