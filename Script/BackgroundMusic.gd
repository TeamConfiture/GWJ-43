extends Node

var MainTheme = load ("res://Art/Audio/Music/MenuTheme.ogg")
var ThemePrincipal = load("res://Art/Audio/Music/IGTheme.ogg")	
var AmbForest = load("res://Art/Audio/Sound/Amb/Forest/ForestAmb_01.ogg")
var AmbCavern = load("res://Art/Audio/Sound/Amb/Cavern/Cavern_drip_01.ogg")

onready var anim_player := $TransitionVolume
onready var track_1 := $Amb_Forest
onready var track_2 := $Amb_Cavern

#--========================================--
#--    Gestion : Nom / Volume Manuel       --
#--========================================--
func _ready():
	pass
	
func play_menu_music():
	
	$Music.stream = MainTheme
	$Music.volume_db = -12
	$Music.play()
	
func play_main_music():
	
	$Music.stream = ThemePrincipal
	$Music.volume_db = -12
	$Music.play()
	
func play_amb_forest():
	
	$Amb_Forest.stream = AmbForest
	$Amb_Forest.play()
	
func play_amb_cavern():
	
	$Amb_Cavern.stream = AmbCavern
	$Amb_Cavern.play()
	
#func chutdown_forestamb():
#	$Amb_Forest.volume_db = -100
#	$Amb_Cavern.volume_db = 0
#
#func chutdown_cavernamb():
#	$Amb_Forest.volume_db = 0
#	$Amb_Cavern.volume_db = -100
	
	
#--========================================--
#--        Gestion : CrossFade Amb         --
#--========================================--

# crossfades to a new audio stream
func crossfade_to():
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if track_1.playing and track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if track_2.playing:
		track_1.stream = AmbForest
		track_1.play()
		anim_player.play("Fade_To_Cavern")
	else:
		track_2.stream = AmbCavern
		track_2.play()
		anim_player.play("Fade_To_Forest")
