extends AudioStreamPlayer

enum SONGS {
	TITLE,
	FOREST
}

const tracks = [
	"kitty_theme",
	"forest_theme",
	]
	
func _play_music(clip_name: String):
	get_stream_playback().switch_to_clip_by_name(clip_name)
	
func change_clip(song: SONGS):
	_play_music(tracks[song])
	
func _ready() -> void:
	play()
	
