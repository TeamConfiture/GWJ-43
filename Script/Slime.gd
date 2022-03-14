extends KinematicBody2D

const Speed = 100

const Grav = 0.0981

var linear_vel:Vector2

var want_jump := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if want_jump:
			linear_vel.y -= 5
			
	else:
		linear_vel.y += Grav
	
	move_and_slide(linear_vel * Speed, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	linear_vel.x = Input.get_axis("ui_left", "ui_right")
	
	want_jump = Input.is_action_just_pressed("ui_up")
	
