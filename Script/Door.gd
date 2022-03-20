extends StaticBody2D

onready var anim_player = $AnimationPlayer

func open():
	anim_player.play("porte")
