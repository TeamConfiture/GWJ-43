extends Node2D


func _on_PlayerDetectorAMBForest_body_entered(body):
	BackgroundMusic.play_menu_music()
	BackgroundMusic.play_amb_forest()
#	BackgroundMusic.chutdown_cavernamb()

func _on_PlayerDetectorAMBForest_body_exited(body):
	BackgroundMusic.crossfadeto()


#func _on_PlayerDetectorAMBCavern_body_entered(body):
#	BackgroundMusic.play_amb_cavern()
#	BackgroundMusic.chutdown_forestamb()
#
#func _on_PlayerDetectorAMBCavern_body_exited(body):
#	BackgroundMusic.chutdown_cavernamb()
