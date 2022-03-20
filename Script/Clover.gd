tool
extends Area2D

export(String, "Red", "Green", "Blue", "Yellow") var clover_type setget set_clover_type

onready var anim = $AnimatedSprite
onready var animplayer = $AnimationPlayer
onready var collision = $CollisionShape2D
onready var timer = $Timer

func set_clover_type(s: String) -> void:
	clover_type = s
	if anim:
		anim.animation = clover_type

func _ready() -> void:
	anim.animation = clover_type

func be_eaten() -> void:
	visible = false
	collision.disabled = true
	timer.start()

func _on_Timer_timeout() -> void:
	animplayer.play("clover_repop")
