extends Camera2D

var screenshake_strength: float = 0
@export var max_screenshake: float = 5
@export var shake_fade: float = 1
var rng = RandomNumberGenerator.new()

func shake_camera(strength: float = -1):
	if strength == -1:
		screenshake_strength = max_screenshake
	else:
		screenshake_strength = strength

func random_coord() -> Vector2:
	return Vector2(
		rng.randf_range(-screenshake_strength, screenshake_strength),
		rng.randf_range(-screenshake_strength, screenshake_strength)
	)

func _process(delta: float) -> void:
	if screenshake_strength > 0:
		screenshake_strength = maxf(screenshake_strength - (max_screenshake / shake_fade) * delta, 0)
		offset = random_coord()
	else:
		offset = Vector2.ZERO
