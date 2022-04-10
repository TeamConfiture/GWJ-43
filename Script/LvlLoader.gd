extends Node


onready var fader = $AnimationPlayer


func _ready():
	$Layer/TransitionColor.visible=true
	
	

func change_lvl_out():
	fader.play("transition_out")
	yield(fader,"animation_finished")

func change_lvl_in():
	fader.play("transition_in")
	yield(fader,"animation_finished")
