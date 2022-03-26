extends Node

func _ready():
	$bg/TransitionColor/AnimationPlayer.play("transition_in")
	BackgroundMusic.play_menu_music()

func _on_play_pressed():
	
	SceneLoader.next_scene()
	BackgroundMusic.play_main_music()

func _on_credits_pressed():
	BackgroundMusic.play_button_normal()
	get_tree().change_scene("res://Scene/Credits.tscn")

func _on_quit_pressed():
	BackgroundMusic.play_button_normal()
	get_tree().quit()

func _on_back_pressed():
	BackgroundMusic.play_button_normal()
	get_tree().change_scene("res://Scene/Menu.tscn")


