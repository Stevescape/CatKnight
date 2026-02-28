extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var gravity: float = 18.75

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

func _ready():
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	
func start_coyote_timer():
	coyote_timer.start()
	
func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		anim_sprite.flip_h = true
	elif velocity.x < 0:
		anim_sprite.flip_h = false
