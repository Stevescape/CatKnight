extends Node

var time: float
var running: bool

func reset_timer():
	time = 0

func pause_timer():
	running = false
	
func resume_timer():
	running = true
	
func start_timer():
	time = 0
	running = true

func format_time(total_seconds: float) -> String:
	var minutes = floor(total_seconds / 60)
	var seconds = int(total_seconds) - (minutes * 60)
	var milliseconds = int(fmod(total_seconds, 1.0) * 1000)
	
	# %02d pads the number with a leading zero if it's a single digit
	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]

func get_time_string():
	return format_time(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if running:
		time = time + delta
		
