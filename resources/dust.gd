extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("dust")
	self.animation_finished.connect(finished)

func finished():
	queue_free()
