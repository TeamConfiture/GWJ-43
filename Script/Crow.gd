tool
extends Area2D




export(String, "Droite", "Gauche" ) var crow_dir setget set_crow_dir

onready var anim = $AnimatedSprite

func set_crow_dir(crow_dir):
	
	if crow_dir == "Gauche":
		$AnimatedSprite.flip_h =false
	else :
		$AnimatedSprite.flip_h =true


func _on_Crow_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		$Rnd_Crow.play(0.0)
		
