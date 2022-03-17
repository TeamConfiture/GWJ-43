tool
extends Area2D

export(String, "Red", "Green", "Blue", "Yellow") var clover_type setget set_clover_type

onready var anim = $AnimatedSprite

func set_clover_type(s: String) -> void:
	clover_type = s
	if anim:
		anim.animation = clover_type

func _ready() -> void:
	anim.animation = clover_type
