tool
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, "Droite", "Gauche") var Crow_dir setget set_crow_dir
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_crow_dir(Crow_dir:String):
	
	if Crow_dir == "Gauche":
		$AnimatedSprite.flip_h =true
	else :
		$AnimatedSprite.flip_h =false

func _on_Crow_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		$AudioStreamPlayer2D.play(0.0)
		


