extends Node

func _on_play_pressed():
	get_tree().change_scene("res://Scene/Tutorial.tscn")

func _on_credits_pressed():
	get_tree().change_scene("res://Scene/Credits.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
