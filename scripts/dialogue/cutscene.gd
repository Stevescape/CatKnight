extends Node2D

var current_dialogue := 0

var dialogue := preload("res://dialogue/cutscene/cutscene_dialogue.dialogue")

var dialogue_titles := [
	"start",
	"birthday",
	"dog_entrance",
	"betrayal",
	"amulet",
	"tiger_amulet",
	"fall_of_kitty",
]

@onready var anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	AudioPlayer.change_clip(AudioPlayer.SONGS.THRONE)

func play_dog_intro():
	AudioPlayer.change_clip(AudioPlayer.SONGS.DOG_INTRO)
	
func play_dog_calm():
	AudioPlayer.change_clip(AudioPlayer.SONGS.DOG_CALM)
	
func play_dog_transition():
	AudioPlayer.change_clip(AudioPlayer.SONGS.DOG_TRANSITION)
	
func play_dog_empowered():
	AudioPlayer.change_clip(AudioPlayer.SONGS.DOG_EMPOWERED)

func play_sfx(fx: AudioPlayer.SFX):
	AudioPlayer.play_sfx(fx)

func advance_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_titles[current_dialogue])
	current_dialogue += 1
	anim_player.pause()

func _on_dialogue_manager_dialogue_ended(dialogue):
	anim_player.play()
	
func swap_to_forest():
	anim_player.play("forest")
	
func swap_scene():
	SceneTransition.change_scene("res://scenes/level_1.tscn")
