extends Node

onready var MenuTheme = load ("res://Art/Audio/Music/MenuTheme.ogg")
onready var ThemePrincipal = load("res://Art/Audio/Music/Level_1.ogg")	
onready var AmbForest = load("res://Art/Audio/Sound/Amb/Forest/ForestAmb_01.ogg")
onready var AmbCavern = load("res://Art/Audio/Sound/Amb/Cavern/Cavern_drip_01.ogg")
onready var AmbUnderwater = load("res://Art/Audio/Sound/Amb/Underwater/Amb_Underwater_1.ogg")

onready var anim_player := $TransitionVolume

func _ready():
	pass
	
func play_button_start():
	$PressButtonStart.play()
func play_button_normal():
	$PressButtonNormal.play()
func play_button_next():
	$Button_Next.play()
	
#--========================================--
#--          Gestion : Music               --
#--========================================--

func play_menu_music():
	
#	$Music.stream = MainTheme
#	$Music.volume_db = -12
#	$Music.play()
	var MainMenuTheme = $MusicMenu.is_playing()
	if !MainMenuTheme:
		anim_player.play("Fade_To_MusicMenu")
		$MusicMenu.stream = MenuTheme
		$MusicMenu.volume_db = -6
		$MusicMenu.play()
#		print("MainMenuTheme")
	
	
func play_main_music():
	
#	$MusicIG.stream = ThemePrincipal
#	$MusicIG.volume_db = -16
#	$MusicIG.play()
	var PrincipalPlay = $MusicIG.is_playing()
	if !PrincipalPlay:
		anim_player.play("Fade_To_IGMusic")
		$MusicIG.stream = ThemePrincipal
		$MusicIG.volume_db = 0
		$MusicIG.play()
#		print("ThemePrincipal")
	
	
#--========================================--
#--          Gestion : Zone Amb            --
#--========================================--

func play_amb_forest():
	var Forest_play = $Amb_Forest.is_playing()
	if !Forest_play:
		anim_player.play("Fade_To_Forest")
		$Amb_Forest.stream = AmbForest
		$Amb_Forest.play()
#		print("Foret")
	
	
func play_amb_cavern():
	var Cavern_play = $Amb_Cavern.is_playing()
	if !Cavern_play:
		anim_player.play("Fade_To_Cavern")
		$Amb_Cavern.stream = AmbCavern
		$Amb_Cavern.play()
#		print("Cavern")

func play_amb_underwater():
	var Underwater_play = $Amb_Underwater.is_playing()
	if !Underwater_play:
		anim_player.play("Fade_To_Underwater")
		$Amb_Underwater.stream = AmbUnderwater
		$Amb_Underwater.play()
#		print("Foret")

