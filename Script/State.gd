extends Node
class_name State

onready var parent = get_parent()

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
	
func state_enabled(b:bool):
	set_process(b)
	set_physics_process(b)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
