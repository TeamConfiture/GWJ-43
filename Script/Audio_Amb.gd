extends Node2D

func _on_PlayerDetectorAMBForest_body_entered(body):
	if body.name == "Slime" :
		BackgroundMusic.play_amb_forest()

func _on_PlayerDetectorAMBForest_body_exited(body):
	pass

func _on_PlayerDetectorAMBCavern_body_entered(body):
	if body.name == "Slime" :BackgroundMusic.play_amb_cavern()

func _on_PlayerDetectorAMBCavern_body_exited(body):
	pass

