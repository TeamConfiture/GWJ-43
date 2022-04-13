extends Node


onready var fader = $AnimationPlayer


func _ready():
	pass
	
	

func change_lvl_out():
	$Layer/TransitionColor.visible=true
	fader.play("transition_out")
	yield(fader,"animation_finished")

func change_lvl_in():
	$Layer/TransitionColor.visible=true
	fader.play("transition_in")
	yield(fader,"animation_finished")
