extends Node2D


var index: = 1


func _process(delta):
	if Input.is_action_just_pressed("spit"):
		_on_NextBtn_pressed()
	
	
func _on_NextBtn_pressed():

	var child = get_child(index)
	child.visible=false
	get_child(index+1).visible=true
	BackgroundMusic.play_button_next()
	index+=1
	if index >=6 :
		SceneLoader.change_scene("Credits")
