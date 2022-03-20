extends Node

var index:= 0

var scenes = [preload("res://Scene/Menu.tscn"), preload("res://Scene/Test.tscn"), preload("res://Scene/Test2.tscn")]

func load_menu():
	index = 0
	
	get_tree().change_scene_to(scenes[index])

func next_scene():
	index +=1
	
	if index >= scenes.size():
		index = scenes.size() - 1
		
	get_tree().change_scene_to(scenes[index])
