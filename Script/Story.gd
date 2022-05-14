extends Node2D

var page = 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spit"):
		_on_NextBtn_pressed()


func _on_NextBtn_pressed():

	var node_var = get_node_or_null('P'+ str(page))
	
	if node_var:
		node_var.visible = false
		page += 1
		AudioManager.play_button_next()
		if page >= 5:
			$NextBtn.visible=false
			$Space.visible=false
			$Arrow.visible=false
			SceneLoader.change_scene("Game")
		else:
			node_var = get_node_or_null('P'+ str(page))
			node_var.visible =true
		
