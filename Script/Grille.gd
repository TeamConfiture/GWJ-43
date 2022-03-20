extends Area2D

onready var Grille = $Grille/CollisionPolygon2D


func _on_Grille_body_entered(body):
	
	if body.name == "Slime":
		
		if body.state == 3 || body.state == 4 :
			Grille.set_deferred("disabled",true)
		
		
		else : 
			Grille.set_deferred("disabled",false)
			
