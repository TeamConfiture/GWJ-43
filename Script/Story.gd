extends Node2D

var page = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextBtn_pressed():
	get_node('P'+ str(page)).visible = false
	page += 1
	if page >= 5:
		$NextBtn.visible=false
		SceneLoader.change_scene("Game")
	else:
		get_node('P'+ str(page)).visible = true
