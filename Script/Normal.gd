extends State

const MulSpeed = 100
const Move_Speed = 0.5
const Stop_Speed = 0.3
const Jump_Acc = 3

var want_jump := false

func _physics_process(delta: float) -> void:
	if parent.is_in_water():
		want_jump = true
	else:
		parent.set_collision_mask_bit(2, 1)
	
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
		if want_jump:
			parent.speed.y -= Jump_Acc
			want_jump = false
	else:
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed * MulSpeed, Vector2.UP)

func _process(delta: float) -> void:
	want_jump = Input.is_action_just_pressed("up")
	
	parent.want_eat = Input.is_action_just_pressed("eat")
	
	if Input.is_action_just_pressed("test_leaf") or parent.normal_to_leaf:
		parent.normal_to_leaf = false
		parent.anim_playback.travel("normal_to_leaf")

	if Input.is_action_just_pressed("test_rock") or parent.normal_to_rock:
		parent.normal_to_rock = false
		parent.anim_playback.travel("normal_to_rock")

	if Input.is_action_just_pressed("test_steam") or parent.normal_to_steam:
		parent.normal_to_steam = false
		parent.anim_playback.travel("normal_to_steam")

	if Input.is_action_just_pressed("test_mud") or parent.normal_to_mud:
		parent.normal_to_mud = false
		parent.anim_playback.travel("normal_to_mud")
	
	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_jumping"] = want_jump
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and parent.speed.x != 0
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and parent.speed.x == 0
