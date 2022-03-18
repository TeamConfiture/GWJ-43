extends Node2D

onready var raycast := $Raycast2D
onready var sprite := $Sprite
onready var line := $Line2D
onready var parent := get_parent()

var hook_origin:Vector2

var hooked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	raycast.add_exception(parent)
	pass # Replace with function body.

func hook_enabled(b:bool):
	sprite.visible = b

func launch() -> bool:
	raycast.enabled = true
	
	raycast.force_raycast_update()
	
	var b = raycast.is_colliding()
	
	if b:
		hook_origin = raycast.get_collision_point()
		
		line.visible = true
		
		set_process(true)
	else:
		line.visible = false
		
		set_process(false)
		
	raycast.enabled = false
	
	return b
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.position = parent.to_local(hook_origin)
	line.set_point_position(1, sprite.position)
