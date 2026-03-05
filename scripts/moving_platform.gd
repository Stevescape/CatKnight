extends PathFollow2D

@export var duration = 3
@export var hold_time = 2
var ease = Tween.EASE_IN_OUT
var trans = Tween.TRANS_QUAD
var tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if tween != null and tween.is_running():
		return
	if not loop:
		non_loop_movement()

		

func non_loop_movement():
	tween = create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.tween_property(self, "progress_ratio", 1, duration).set_delay(hold_time)
	tween.tween_property(self, "progress_ratio", 0, duration).set_delay(hold_time)
	
func loop_movement():
	progress_ratio = 0
	tween = create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.tween_property(self, "progress_ratio", 1, duration).set_delay(hold_time)
