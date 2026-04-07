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
	
func _random_pitch():
	return randf_range(min_pitch, max_pitch)
	
func play_sfx(sfx_enum: SFX):
	var player = SFX_PLAYERS[sfx_enum]
	player.pitch_scale = _random_pitch()
	player.play()
	
func change_clip(song: SONGS):
	_play_music(tracks[song])
	
func _ready() -> void:
	play()
	
