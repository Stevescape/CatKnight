extends Camera2D

@export var max_screenshake: float = 30
@export var shake_fade: float = 5

var screenshake_strength: float = 0.0

@export var character: CharacterBody2D

var rng = RandomNumberGenerator.new()

func shake_camera():
	screenshake_strength = max_screenshake

func _process(delta: float) -> void:
	if screenshake_strength > 0:
		screenshake_strength = lerpf(screenshake_strength, 0, shake_fade * delta)
		offset = random_coord()


func _physics_process(delta: float) -> void:
	position = lerp(position, character.position, 0.1)
	
	

func random_coord() -> Vector2:
	return Vector2(rng.randf_range(-screenshake_strength, screenshake_strength), rng.randf_range(-screenshake_strength, screenshake_strength))
