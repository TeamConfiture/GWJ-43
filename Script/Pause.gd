extends CanvasLayer


var pause := false
onready var parchemin = $Parchemin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause = !pause
		get_tree().paused=pause
		parchemin.visible = pause



func _on_Menu_pressed():
	get_tree().paused=false
	parchemin.visible = false
	SceneLoader.change_scene("Menu")


func _on_Resume_pressed():
	pause = false
	get_tree().paused=pause
	parchemin.visible = pause
