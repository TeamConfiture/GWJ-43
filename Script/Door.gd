extends StaticBody2D

signal door_to_open
onready var anim_player = $AnimationPlayer

func open():
	get_tree().get_root().get_node("Game").find_the_wayout(position)

	anim_player.play("porte")
