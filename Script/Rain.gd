extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Rain = $Sprite_1/Rain

# Called when the node enters the scene tree for the first time.
func _ready():
		Rain.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		Rain.visible = true
		$Rain.play(0.0)
