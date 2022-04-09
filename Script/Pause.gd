extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pause := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause = !pause
		get_tree().paused=pause
		self.visible = pause
		


func _on_Menu_pressed():
	SceneLoader.change_scene("Menu")


func _on_Resume_pressed():
	pause = false
	get_tree().paused=pause
	self.visible = pause
