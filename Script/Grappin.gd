extends Node2D

onready var raycast := $Raycast2D
onready var sprite := $Sprite
onready var line := $Line2D
onready var parent := get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast.add_exception(parent)
	pass # Replace with function body.

func hook_enabled(b:bool):
	sprite.visible = b

func launch():
	raycast.enabled = true
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var local_point = parent.to_local(raycast.get_collision_point())
		
		line.set_point_position(1, local_point)
		line.visible = true
		
		sprite.position = local_point
		
	raycast.enabled = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
