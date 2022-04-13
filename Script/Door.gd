extends StaticBody2D

onready var anim_player = $AnimationPlayer

func open():
#	$root/Game.
	anim_player.play("porte")
