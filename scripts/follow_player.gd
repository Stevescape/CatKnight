extends Camera2D

@export var max_screenshake: float = 30
@export var shake_fade: float = 5

@export var acceleration: float = 5
@export var max_accel: float = 20
@export var x_deadzone: float = 64
@export var max_lookahead: float = 80
var camera_speed = 5
var lookahead = 0
var dir_multiplier: float = 0.0
var dir_duration: float = 0.8

var screenshake_strength: float = 0.0

@export var character: CharacterBody2D

var rng = RandomNumberGenerator.new()
func shake_camera():
	screenshake_strength = max_screenshake

func _process(delta: float) -> void:
	if screenshake_strength > 0 :
		screenshake_strength = lerpf(screenshake_strength, 0, shake_fade * delta)
		offset = random_coord()
		

func _physics_process(delta: float) -> void:
	var dir = character.velocity.normalized().x
	if dir != 0:
		dir_multiplier += (delta * dir)/dir_duration
	dir_multiplier = clamp(dir_multiplier, -1, 1)
	lookahead = max_lookahead * dir_multiplier

	var target_x = character.position.x + lookahead
	position.x = lerp(position.x, target_x, camera_speed * delta)
	position.y = lerp(position.y, character.position.y, camera_speed * delta)
	position = position.round()
		
	
	

func random_coord() -> Vector2:
	return Vector2(rng.randf_range(-screenshake_strength, screenshake_strength), rng.randf_range(-screenshake_strength, screenshake_strength))
