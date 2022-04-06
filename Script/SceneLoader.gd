extends Node



var scenes = {
	"Menu": preload("res://Scene/Menu.tscn"), 
	"Story": preload("res://Scene/Story.tscn"),
	"Game": preload("res://Scene/Game.tscn"),
	"Credits": preload("res://Scene/Credits.tscn")

	}
onready var fader = $AnimationPlayer


func _ready():
	$Layer/TransitionColor.visible=true
	fader.play("transition_in")
	

func change_scene(scene_id:String):


	fader.play("transition_out")

	yield(fader,"animation_finished")

	get_tree().change_scene_to(scenes[scene_id])

	fader.play("transition_in")

