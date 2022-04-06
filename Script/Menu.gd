extends Node

func _ready():
	BackgroundMusic.play_menu_music()

func _on_play_pressed():
	SceneLoader.change_scene("Story")
	BackgroundMusic.play_main_music()

func _on_credits_pressed():
	BackgroundMusic.play_button_normal()
	SceneLoader.change_scene("Credits")

func _on_quit_pressed():
	BackgroundMusic.play_button_normal()
	get_tree().quit()

func _on_back_pressed():
	BackgroundMusic.play_button_normal()
	SceneLoader.change_scene("Menu")


