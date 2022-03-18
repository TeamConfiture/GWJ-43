extends Node

var MainTheme = load ("res://Art/Audio/Music/MenuTheme.ogg")
var ThemePrincipal = load("res://Art/Audio/Music/IGTheme.ogg")	
	
func _ready():
	pass
	
func play_menu_music():
	
	$MenuTheme.stream = MainTheme
	$MenuTheme.play()
	
func play_main_music():
	
	$IGTheme.stream = ThemePrincipal
	$IGTheme.play()
	

# References to the nodes in our scene
onready var _anim_player := $FadeInAndOut
onready var _track_1 := $MenuTheme
onready var _track_2 := $IGTheme


# crossfades to a new audio stream
func crossfade_to(audio_stream: AudioStream) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _track_1.playing and _track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if _track_2.playing:
		_track_1.stream = audio_stream
		_track_1.play()
		_anim_player.play("Fade_In_to_MenuTheme")
	else:
		_track_2.stream = audio_stream
		_track_2.play()
		_anim_player.play("Fade_In_to_IGTheme")
