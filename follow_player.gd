extends Camera2D

@export var character: CharacterBody2D

func _physics_process(delta: float) -> void:
	position = lerp(position, character.position, 0.1)
