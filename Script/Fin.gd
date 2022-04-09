extends Node2D


var index: = 1

func _on_NextBtn_pressed():

	var child = get_child(index)
	child.visible=false
	get_child(index+1).visible=true
	index+=1
	if index >=6 :
		SceneLoader.change_scene("Credits")
