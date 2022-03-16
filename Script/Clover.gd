tool
extends Area2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(String, "Red", "Green", "Blue", "Yellow") var clover_type setget set_clover_type

onready var anim = $AnimatedSprite

func set_clover_type(s:String):
	clover_type = s
	if anim:
		anim.animation = clover_type
