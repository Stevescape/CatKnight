extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()

enum SONGS {
	TITLE,
	FOREST
}

enum SFX {
	OPTIONSFX,
	JUMP,
	DASH,
	LAND,
	DEATH,
	CHECKPOINT,
	SPRING,
}

var min_pitch = 0.75
var max_pitch = 1.25

var master_volume = 50:
	set(value):
		master_volume = value
		value = value/100
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

var music_volume = 50:
	set(value):
		music_volume = value
		value = value/100
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
		
var sfx_volume = 50:
	set(value):
		sfx_volume = value
		value = value/100
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

@onready var SFX_PLAYERS = [
	$OptionSelectPlayer,
	$JumpPlayer,
	$DashPlayer,
	$LandPlayer,
	$DeathPlayer,
	$CheckpointPlayer,
	$SpringPlayer
]

const tracks = [
	"kitty_theme",
	"forest_theme",
	]
	
func _play_music(clip_name: String):
	get_stream_playback().switch_to_clip_by_name(clip_name)
	
func _random_pitch(min, max):
	return randf_range(min, max)
	
func play_sfx(sfx_enum: SFX, min_par=999, max_par=999):
	var player = SFX_PLAYERS[sfx_enum]
	var min_num
	var max_num
	if min_par != 999:
		min_num = min_par
	else:
		min_num = min_pitch
	
	if max_par != 999:
		max_num = max_par
	else:
		max_num = max_pitch
		
	
	player.pitch_scale = _random_pitch(min_num, max_num)
	player.play()
	
func change_clip(song: SONGS):
	_play_music(tracks[song])
	
func _ready() -> void:
	play()
	
func _process(delta):
	var playback = get_stream_playback()
	var playing_clip_name = stream.get_clip_name(get_stream_playback().get_current_clip_index())
	if playback and playback.is_playing() == false:
		playback.switch_to_clip_by_name(playing_clip_name) # loop manually
	
