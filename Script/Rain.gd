extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Rain = $Sprite_1/Rain

# Called when the node enters the scene tree for the first time.
func _ready():
		Rain.visible = false



func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		Rain.visible = true
		$Sprite_1/Rain2.play(0.0)
