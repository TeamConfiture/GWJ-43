extends Node2D

const rot_ray = [-225, -180, -145]

onready var raycast := $Raycast2D
onready var sprite := $Sprite
onready var line := $Line2D
onready var parent := get_parent()
onready var anim_player = $AnimationPlayer

var hook_origin:Vector2

var hooked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	raycast.add_exception(parent)
	pass # Replace with function body.

func hook_enabled(b:bool):
	sprite.visible = b
	
	if !b:
		line.visible = false
		set_process(false)

func set_left():
	anim_player.play("Hook_Left")
	
func set_up():
	anim_player.play("Hook_Up")
	
func set_right():
	anim_player.play("Hook_Right")

func hook_reset():
	set_up()
	line.visible = false
	set_process(false)

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
