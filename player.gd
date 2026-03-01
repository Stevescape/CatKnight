extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var gravity: float = 18.75
var acceleration: float = speed * 20

# air dash
@export var air_dash_speed: float = 375.0
@export var air_dash_duration: float = 0.2
var air_dash_available: bool = true # resets on landing

@export var coyote_time: float = 0.15
var coyote_timer: Timer

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0

# jump settings
@export var jump_cut_multiplier = 5
@export var fall_gravity_multiplier = 10
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dust = preload("res://resources/Dust.tscn")
@onready var camera = get_tree().root.get_child(0).get_node("Camera2D")

var sprites: Array = [
	preload("res://sprites/helmetless.tres"),
	preload("res://sprites/helmet.tres")
]

enum Direction { LEFT= -1, RIGHT=1 }

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

func spawn_dust():
	var obj = dust.instantiate()
	get_tree().root.add_child(obj)
	obj.global_position = global_position
	
func shake_camera():
	if camera != null:
		camera.shake_camera()

func _ready():
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	
func start_coyote_timer():
	coyote_timer.start()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if cur_sprite == 0:
			cur_sprite = 1
		else:
			cur_sprite = 0
	
	if velocity.x > 0:
		anim_sprite.flip_h = true
		last_direction = Direction.RIGHT
	elif velocity.x < 0:
		anim_sprite.flip_h = false
		last_direction = Direction.LEFT
		
	
