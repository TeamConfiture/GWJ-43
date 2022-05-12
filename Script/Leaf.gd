extends State

var Leaf_Platform = preload("res://Scene/Leaf_Platform.tscn")

const Max_Grav = 500

const Max_Speed = 100
const Move_Speed = 0.5
const Stop_Speed = 0.3

const Rot_Speed_Min = 0.05
const Rot_Speed_Max = 0.15

const Chain_Pull = 50

enum State{normal = 0, hook}

var state:int

var want_jump := false

var in_the_air := true

onready var jump_acc = parent.Grav * 30
onready var node_game = get_node("/root/Game")
onready var timer = $Timer

func do_physics_process(delta: float) -> void:
	if parent.is_in_water():
		parent.anim_playback.travel("spitting")
	
	if parent.is_on_floor():
		if in_the_air:
			parent._on_landing()
			in_the_air = false
			
		parent.speed.y = parent.Grav
		
		if want_jump and parent.anim_playback.get_current_node() in ["idle", "walking"]:
			parent.speed.y -= jump_acc
			want_jump = false
	else:
		if !in_the_air:
			in_the_air = true
		
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed, Vector2.UP)

func do_process(delta: float) -> void:
	want_jump = Input.is_action_just_pressed("jump")
	
	if parent.is_on_floor():
		parent.want_eat = Input.is_action_just_pressed("eat")
	elif timer.is_stopped() and Input.is_action_just_pressed("eat"):
		var platform = Leaf_Platform.instance()
		
		platform.position = parent.position + Vector2(0, 10)
		
		node_game.add_child(platform)
		
		timer.start()

	if Input.is_action_just_pressed("spit"):
		parent.anim_playback.travel("spitting")
		
	if Input.is_action_just_pressed("test_normal") \
		or parent.normal_to_mud or parent.normal_to_rock or parent.normal_to_steam:
		parent.anim_playback.travel("to_normal")
	
	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_jumping"] = want_jump
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and !is_zero_approx(parent.speed.x)
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and is_zero_approx(parent.speed.x)
