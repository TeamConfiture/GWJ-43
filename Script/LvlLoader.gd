extends Node


onready var fader = $AnimationPlayer


func _ready():
	$Layer/TransitionColor.visible=true
	fader.play("transition_in")
	

	
func change_lvl():
#	fader.play("transition_out")
#
#	yield(fader,"animation_finished")

	fader.play("transition_in")	



