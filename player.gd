extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 500.0
@export var jump_velocity: float = -700.0
@export var gravity: float = 1400.0

# air dash
@export var air_dash_speed: float = 1100.0
@export var air_dash_duration: float = 0.10
var air_dash_available: bool = true # resets on landing

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0
