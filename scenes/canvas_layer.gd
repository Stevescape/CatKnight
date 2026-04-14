extends CanvasLayer

@onready var hearts = [
	$HUD/Heart,
	$HUD/Heart2,
	$HUD/Heart3,
	$HUD/Heart4,
	$HUD/Heart5
]

var previous_health := 5

func update_hearts(current_health):

	if current_health < previous_health:
		var lost_index = current_health

		if lost_index >= 0 and lost_index < hearts.size():
			play_heart_loss_effect(hearts[lost_index])

	previous_health = current_health

func play_heart_loss_effect(heart):
	if heart == null:
		return

	print("ANIMATING:", heart.name)

	heart.visible = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	var original_scale = Vector2(1, 1)

	heart.scale = Vector2(2.2, 2.2)
	tween.tween_property(heart, "scale", original_scale, 0.25)

	heart.modulate = Color(1, 0.2, 0.2, 1)

	tween.tween_callback(func():
		heart.modulate = Color(0.5, 0.5, 0.5, 1)
	)
