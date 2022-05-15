extends State

const Max_Speed = 130 #
const Move_Speed = 0.5
const Stop_Speed = 0.3

onready var jump_acc = parent.Grav * 30

var want_jump := false

var in_the_air := true

func do_transform():
	if parent.normal_to_leaf:
		parent.normal_to_leaf = false
		parent.anim_playback.travel("normal_to_leaf")

	if parent.normal_to_rock:
		parent.normal_to_rock = false
		parent.anim_playback.travel("normal_to_rock")

	if parent.normal_to_steam:
		parent.normal_to_steam = false
		parent.anim_playback.travel("normal_to_steam")

	if parent.normal_to_mud:
		parent.normal_to_mud = false
		parent.anim_playback.travel("normal_to_mud")

func state_enabled(b:bool):
	.state_enabled(b)
	
	do_transform()

func do_physics_process(_delta: float) -> void:
	if parent.is_in_water():
		want_jump = true
	else:
		parent.set_collision_mask_bit(2, 1)
	
	if parent.is_on_floor():
		if in_the_air:
			parent._on_start_landing()
			in_the_air = false
		
		parent.speed.y = parent.Grav
		if want_jump and parent.anim_playback.get_current_node() in ["idle", "walking"]:
			parent.speed.y -= jump_acc
			want_jump = false
	else:
		if !in_the_air:
			in_the_air = true
		
		if !parent.is_in_water():
			parent.speed.y += parent.Grav
		else:
			parent.speed.y = -jump_acc

	parent.move_and_slide(parent.speed, Vector2.UP)

func do_process(_delta: float) -> void:
	want_jump = Input.is_action_just_pressed("jump")
	
	parent.want_eat = Input.is_action_just_pressed("eat")
	
	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_jumping"] = want_jump
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	
	var tmp_my_is_zero_approx = parent.my_is_zero_approx(parent.speed.x)
	
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and !tmp_my_is_zero_approx
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and tmp_my_is_zero_approx
