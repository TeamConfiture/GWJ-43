extends Node

#Déclaration des musiques du jeu
onready var M_Menu = load ("res://Art/Audio/Music/M_Menu.ogg")
onready var M_Main = load("res://Art/Audio/Music/M_Main.ogg")	
onready var M_Cave = load("res://Art/Audio/Music/M_Cave.ogg")

#Déclaration des ambiances du jeu
onready var Amb_Forest = load("res://Art/Audio/Ambiant/Forest/Amb_Forest.ogg")
onready var Amb_Cavern = load("res://Art/Audio/Ambiant/Cavern/Amb_Cavern.ogg")
onready var Amb_Underwater = load("res://Art/Audio/Ambiant/Underwater/Amb_Underwater.ogg")

#Déclaration des chemin d'animation pour des Fade In / Out propre et controlé
onready var Fade_Music := $Transition/Fade_Music
onready var Fade_Ambiant := $Transition/Fade_Ambiant
onready var Fade_Effect := $Transition/Fade_Effect

func _ready():
	pass

#--========================================--
#--        Gestion : OneShotAudio          --
#--========================================--

func play_button_start():				#Bouton Start du menu principal quand on lance le jeu
	$Interface/PressButtonStart.play()
func play_button_normal():				#Bouton "Next" et "Back" dans les menus
	$Interface/PressButtonNormal.play()
func play_button_next():				#Bouton "Next" dans le parchemin histoire début et fin de jeu
	$Interface/Button_Next.play()
func play_InteracableButton():			#Bouton intéraction avec le slime pour ouvrir les portes
	$Interacable/InteracableButton.play()
func play_Score():						#Défilement du nombre de pièce en fin de niveau
	$Interface/Count_Score.play()
	
#--========================================--
#--          Gestion : Music               --
#--========================================--

func play_menu_music():
	
	var Menu_Play = $Musics/M_Menu.is_playing()
	if !Menu_Play:
		Fade_Music.play("Fade_To_M_Menu")
		$Musics/M_Menu.stream = M_Menu
		$Musics/M_Menu.volume_db = -8
		$Musics/M_Menu.play()
	
	
func play_main_music():
	
	var Main_Play = $Musics/M_Main.is_playing()
	if !Main_Play:
		Fade_Music.play("Fade_To_M_Main")
		$Musics/M_Main.stream = M_Main
		$Musics/M_Main.volume_db = -4
		$Musics/M_Main.play()


func play_cave_music():
	
	var Cave_Play = $Musics/M_Cave.is_playing()
	if !Cave_Play:
		Fade_Music.play("Fade_To_M_Cave")
		$Musics/M_Cave.stream = M_Cave
		$Musics/M_Cave.volume_db = -8
		$Musics/M_Cave.play()
	
#--========================================--
#--          Gestion : Zone Amb            --
#--========================================--

func play_amb_forest():
	var Ambiant_Forest = $Ambiant/Amb_Forest.is_playing()
	if !Ambiant_Forest:
		Fade_Ambiant.play("Fade_To_Forest")
		$Ambiant/Amb_Forest.stream = Amb_Forest
		$Ambiant/Amb_Forest.play()
	
	
func play_amb_cavern():
	var Ambiant_Cavern = $Ambiant/Amb_Cavern.is_playing()
	if !Ambiant_Cavern:
		Fade_Ambiant.play("Fade_To_Cavern")
		$Ambiant/Amb_Cavern.stream = Amb_Cavern
		$Ambiant/Amb_Cavern.play()


func play_amb_underwater():
	var Ambiant_Underwater = $Ambiant/Amb_Underwater.is_playing()
	if !Ambiant_Underwater:
		Fade_Effect.play("Fade_To_Underwater")
		$Ambiant/Amb_Underwater.stream = Amb_Underwater
		$Ambiant/Amb_Underwater.play()
		
		
		
			
