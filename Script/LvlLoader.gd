extends Node


onready var fader = $AnimationPlayer


func _ready():
	$Layer/TransitionColor.visible=true
	fader.play("transition_in")
	

	
func to_white():
	fader.play("transition_in")


func to_black():
	fader.play("transition_out")



