extends Node

onready var hud := $HUD

var coins := 0

func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)
	
	pass # Replace with function body.
