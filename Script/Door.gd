extends StaticBody2D


onready var anim_player = $AnimationPlayer

func open():
	var game = get_tree().get_root().get_node("Game")
	
	game.find_the_wayout(position)

	yield(game,"open_door")
	anim_player.play("porte")
	AudioManager.play_Doors()
	yield(anim_player,"animation_finished")
	game._on_door_open()




