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
	$Interface/PressButtonStart.play()
func play_button_normal():
	$Interface/PressButtonNormal.play()
func play_button_next():
	$Interface/Button_Next.play()
func play_InteracableButton():
	$Interacable/InteracableButton.play()
func play_Score():
	$Interface/Count_Score.play()
	
#--========================================--
#--          Gestion : Music               --
#--======================================	==--

func play_menu_music():
	
#	$Music.stream = MainTheme
#	$Music.volume_db = -12
#	$Music.play()
	var MainMenuTheme = $Musics/MusicMenu.is_playing()
	if !MainMenuTheme:
		anim_player.play("Fade_To_MusicMenu")
		$Musics/MusicMenu.stream = MenuTheme
		$Musics/MusicMenu.volume_db = -6
		$Musics/MusicMenu.play()
#		print("MainMenuTheme")
	
	
func play_main_music():
	
#	$MusicIG.stream = ThemePrincipal
#	$MusicIG.volume_db = -16
#	$MusicIG.play()
	var PrincipalPlay = $Musics/MusicIG.is_playing()
	if !PrincipalPlay:
		anim_player.play("Fade_To_IGMusic")
		$Musics/MusicIG.stream = ThemePrincipal
		$Musics/MusicIG.volume_db = 0
		$Musics/MusicIG.play()
#		print("ThemePrincipal")
	
	
#--========================================--
#--          Gestion : Zone Amb            --
#--========================================--

func play_amb_forest():
	var Forest_play = $Ambiant/Amb_Forest.is_playing()
	if !Forest_play:
		anim_player.play("Fade_To_Forest")
		$Ambiant/Amb_Forest.stream = AmbForest
		$Ambiant/Amb_Forest.play()
#		print("Foret")
	
	
func play_amb_cavern():
	var Cavern_play = $Ambiant/Amb_Cavern.is_playing()
	if !Cavern_play:
		anim_player.play("Fade_To_Cavern")
		$Ambiant/Amb_Cavern.stream = AmbCavern
		$Ambiant/Amb_Cavern.play()
#		print("Cavern")

func play_amb_underwater():
	var Underwater_play = $Ambiant/Amb_Underwater.is_playing()
	if !Underwater_play:
		anim_player.play("Fade_To_Underwater")
		$Ambiant/Amb_Underwater.stream = AmbUnderwater
		$Ambiant/Amb_Underwater.play()
#		print("Foret")

