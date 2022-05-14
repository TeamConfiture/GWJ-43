extends Node2D


var index: = 1


func _process(_delta):
	if Input.is_action_just_pressed("spit"):
		_on_NextBtn_pressed()
	
	
func _on_NextBtn_pressed():

	var node_var = get_node_or_null('End_'+ str(index))
	
	if node_var:
		node_var.visible = false
		index += 1
		AudioManager.play_button_next()
		if index >= 6:
			$NextBtn.visible=false
			$Space.visible=false
			SceneLoader.change_scene("Credits")
		else:
			node_var = get_node_or_null('End_'+ str(index))
			node_var.visible =true
