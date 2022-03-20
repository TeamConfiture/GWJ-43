extends Node

func _ready():
	BackgroundMusic.play_menu_music()

func _on_play_pressed():
	SceneLoader.next_scene()
	BackgroundMusic.play_main_music()

func _on_credits_pressed():
	get_tree().change_scene("res://Scene/Credits.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
