extends KinematicBody2D

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree

const MulSpeed = 100
const Normal_Move_Speed = 0.5
const Normal_Stop_Speed = 0.3
const Steam_Stop_Speed = 0.02
const Grav = 0.0981
const Jump_Acc = 2.5

var linear_vel:Vector2

var dir:Vector2

var speed:Vector2

var want_jump := false

enum State{normal = 0, steam}

var state = State.normal

var move_speed = Normal_Move_Speed

var stop_speed = Normal_Stop_Speed

var val = 0
var val_max = -15
var val_acc = val_max*0.075
var val_mode := false

var is_falling := true

var want_eat := false

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
				speed.y = Grav
				if is_falling:
					is_falling = false
				if want_jump:
					speed.y -= Jump_Acc
			else:
				if !is_falling:
					is_falling = true
				speed.y += Grav
#				sprite.animation = "normal_falling"
	
	move_and_slide(speed * MulSpeed + Vector2(0, val), Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir.x = Input.get_axis("ui_left", "ui_right")
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
	speed.x = get_speed(dir.x, speed.x)
	
	match(state):
		State.normal:
			want_jump = Input.is_action_just_pressed("ui_up")
			
			want_eat = Input.is_action_just_pressed("ui_accept")
		
		State.steam:
			val -= -val_acc
			
			if val < val_max:
				val = -val_max
			
			dir.y = Input.get_axis("ui_up", "ui_down")
			
			dir = dir.normalized()
			
			speed.y = get_speed(dir.y, speed.y)
			
#	if Input.is_action_just_pressed("ui_accept"):
#		state = State.steam
#
#		stop_speed = Steam_Stop_Speed

	var is_on_floor = is_on_floor()

	anim_tree["parameters/conditions/is_jumping"] = want_jump
	anim_tree["parameters/conditions/is_eating"] = want_eat
	anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	anim_tree["parameters/conditions/is_moving"] = is_on_floor and speed.x != 0
	anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and speed.x == 0
