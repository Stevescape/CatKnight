extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()

enum SONGS {
	TITLE,
	FOREST,
	THRONE,
	DOG_INTRO,
	DOG_CALM,
	DOG_TRANSITION,
	DOG_EMPOWERED,
	GAME_OVER,
}

enum SFX {
	OPTIONHOVERSFX,
	JUMP,
	DASH,
	LAND,
	DEATH,
	CHECKPOINT,
	SPRING,
	AMULET,
	QUAKE,
	THUNDER,
	CRUMBLE,
	PAPER,
	OPTIONSFX,
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
	$OptionHoverPlayer,
	$JumpPlayer,
	$DashPlayer,
	$LandPlayer,
	$DeathPlayer,
	$CheckpointPlayer,
	$SpringPlayer,
	$Amulet,
	$Rumble,
	$Thunder,
	$WallCrumble,
	$Paper,
	$OptionSelectPlayer,
]

const tracks = [
	"kitty_theme",
	"forest_theme",
	"throne_room",
	"dog_intro",
	"dog_calm",
	"dog_transition",
	"dog_empowered",
	"game_over",
	]
	
func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	play_sfx(SFX.OPTIONHOVERSFX)

func _play_pressed() -> void:
	play_sfx(SFX.OPTIONSFX)
	
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
	
	
