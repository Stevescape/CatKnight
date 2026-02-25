extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 500.0
@export var jump_velocity: float = -1100.0
@export var gravity: float = 35

# air dash
@export var air_dash_speed: float = 1100.0
@export var air_dash_duration: float = 0.10
var air_dash_available: bool = true # resets on landing

@export var coyote_time: float = 0.15
var coyote_timer: Timer

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0

func _ready():
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	
func start_coyote_timer():
	coyote_timer.start()
