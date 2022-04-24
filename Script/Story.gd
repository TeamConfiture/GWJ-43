extends Node2D

var page = 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		_on_NextBtn_pressed()


func _on_NextBtn_pressed():
	get_node('P'+ str(page)).visible = false
	page += 1
	BackgroundMusic.play_button_next()
	if page >= 5:
		$NextBtn.visible=false
		SceneLoader.change_scene("Game")
	else:
		get_node('P'+ str(page)).visible = true
