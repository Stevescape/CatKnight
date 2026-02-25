extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 1000.0
@export var jump_velocity: float = -1800.0
@export var gravity: float = 75

# air dash
@export var air_dash_speed: float = 1500.0
@export var air_dash_duration: float = 0.2
var air_dash_available: bool = true # resets on landing

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0

# jump settings
@export var jump_cut_multiplier = 5
@export var fall_gravity_multiplier = 10
