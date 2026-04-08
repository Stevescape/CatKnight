extends Sprite2D
class_name LitterBox

func update_sprite() -> void:
	if $Marker2D.global_position == Checkpoint.checkpoint_pos:
		frame = 1
	else:
		frame = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Checkpoint.checkpoint_pos == $Marker2D.global_position:
			return
		AudioPlayer.play_sfx(AudioPlayer.SFX.CHECKPOINT, 1, 1)
		Checkpoint.checkpoint_pos = $Marker2D.global_position
		if Checkpoint.prev_checkpoint_sprite != null:
			Checkpoint.prev_checkpoint_sprite.update_sprite()
		print("update checkpoint")
		Checkpoint.prev_checkpoint_sprite = self
		update_sprite()
