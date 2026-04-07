extends StaticBody2D

signal collided

@export var jump_height = 125
@export var cooldown: int = 1
@onready var sm: StateMachine = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func calc_velocity(jump_height, gravity):
	return -sqrt(2 * gravity * jump_height)

func _ready():
	collided.connect(func(obj):
		sm.force_change_state("cooldown")
		obj.velocity.y = calc_velocity(jump_height, obj.gravity * 60)
		AudioPlayer.play_sfx(AudioPlayer.SFX.SPRING)
	)
