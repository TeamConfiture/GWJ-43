extends Node

onready var MainTheme = load ("res://Art/Audio/Music/MenuTheme.ogg")
onready var ThemePrincipal = load("res://Art/Audio/Music/IGTheme.ogg")	
onready var AmbForest = load("res://Art/Audio/Sound/Amb/Forest/ForestAmb_01.ogg")
onready var AmbCavern = load("res://Art/Audio/Sound/Amb/Cavern/Cavern_drip_01.ogg")

onready var anim_player := $TransitionVolume

func _ready():
	pass
	
#--========================================--
#--          Gestion : Music               --
#--========================================--

func play_menu_music():
	
	$Music.stream = MainTheme
	$Music.volume_db = -24
	$Music.play()
	
	
func play_main_music():
	
	$Music.stream = ThemePrincipal
	$Music.volume_db = -24
	$Music.play()
	
	
#--========================================--
#--          Gestion : Zone Amb            --
#--========================================--

func play_amb_forest():
	var Forest_play = $Amb_Forest.is_playing()
	if !Forest_play:
		anim_player.play("Fade_To_Forest")
		$Amb_Forest.stream = AmbForest
		$Amb_Forest.play()
		print("Foret")
	
	
func play_amb_cavern():
	var Cavern_play = $Amb_Cavern.is_playing()
	if !Cavern_play:
		anim_player.play("Fade_To_Cavern")
		$Amb_Cavern.stream = AmbCavern
		$Amb_Cavern.play()
		print("Cavern")
	
	
