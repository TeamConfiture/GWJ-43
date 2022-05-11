extends Node2D

#--========================================--
#--     Gestion Ambiance Fade in / Out     --
#--========================================--
func _on_PlayerDetectorAMBForest_body_entered(body):
	if body.name == "Slime" :
		AudioManager.play_amb_forest()

func _on_PlayerDetectorAMBCavern_body_entered(body):
	if body.name == "Slime" :
		AudioManager.play_amb_cavern()
		
#--========================================--
#--Gestion Filtre, sur Bus Audio "Underwater"--
#--========================================--

func _on_UnderWater_body_entered(body):
	var bus_idx = AudioServer.get_bus_index("Underwater")
	var effect_idx = AudioServer.get_bus_effect(bus_idx, 0)
	if body.name == "Slime" :
		effect_idx.set_cutoff(1500)
		AudioManager.play_amb_underwater()


func _on_UnderWater_body_exited(body):
	var bus_idx = AudioServer.get_bus_index("Underwater")
	var effect_idx = AudioServer.get_bus_effect(bus_idx, 0)
	if body.name == "Slime" :
		effect_idx.set_cutoff(20500)
