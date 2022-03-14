extends KinematicBody2D

const MulSpeed = 100
const Normal_Move_Speed = 0.5
const Normal_Stop_Speed = 0.3
const Steam_Stop_Speed = 0.02
const Grav = 0.0981
const Jump_Acc = 5

var linear_vel:Vector2

var dir:Vector2

var speed:Vector2

var want_jump := false

enum State{normal = 0, steam}

var state = State.normal

var move_speed = Normal_Move_Speed

var stop_speed = Normal_Stop_Speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_speed(_dir:float, _speed:float) -> float:
	if _dir != 0:
		return clamp(_speed+_dir*move_speed, -1, 1)
	return sign(_speed)*clamp(abs(_speed)-stop_speed, 0, 1)

func _physics_process(delta: float) -> void:
	match(state):
		State.normal:
			if is_on_floor():
				if want_jump:
					speed.y -= Jump_Acc
					
			else:
				speed.y += Grav
		
		State.steam:
			speed.y += rand_range(-0.1, 0.1)
	
	move_and_slide(speed * MulSpeed, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir.x = Input.get_axis("ui_left", "ui_right")
	
	speed.x = get_speed(dir.x, speed.x)
	
	match(state):
		State.normal:
			want_jump = Input.is_action_just_pressed("ui_up")
		
		State.steam:
			dir.y = Input.get_axis("ui_up", "ui_down")
			
			dir = dir.normalized()
			
			speed.y = get_speed(dir.y, speed.y)
			
	if Input.is_action_just_pressed("ui_accept"):
		state = State.steam
		
		stop_speed = Steam_Stop_Speed
