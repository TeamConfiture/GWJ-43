extends Node

func _ready():
	AudioManager.play_menu_music()

func _on_play_pressed():
	SceneLoader.change_scene("Story")
	AudioManager.play_main_music()
	AudioManager.play_button_start()

func _on_credits_pressed():
	AudioManager.play_button_normal()
	SceneLoader.change_scene("Credits")

func _on_quit_pressed():
	AudioManager.play_button_normal()
	get_tree().quit()

func _on_back_pressed():
	AudioManager.play_button_normal()
	SceneLoader.change_scene("Menu")
	AudioManager.play_menu_music()

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("spit"):
		AudioManager.play_button_normal()
		SceneLoader.change_scene("Game")
