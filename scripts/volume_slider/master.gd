extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Volume: " + str(AudioPlayer.master_volume))
	value = AudioPlayer.master_volume
