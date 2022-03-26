extends Position2D


var SlimeScene =  preload("res://Scene/Slime.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var Slime = SlimeScene.instance()
	add_child(Slime)

