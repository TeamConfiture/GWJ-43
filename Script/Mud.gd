extends State

const MulSpeed = 200
const Move_Speed = 0.5
const Stop_Speed = 0.3

func do_physics_process(delta: float) -> void:
	parent.set_collision_mask_bit(2, 0)
	
	if parent.is_in_water():
		parent.anim_playback.travel("spitting")
	
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
	else:
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed * MulSpeed, Vector2.UP)

func do_process(delta: float) -> void:
	if Input.is_action_just_pressed("test_normal") \
	or Input.is_action_just_pressed("spit") \
	or parent.normal_to_leaf or parent.normal_to_rock or parent.normal_to_steam:
		parent.anim_playback.travel("spitting")

	parent.want_eat = Input.is_action_just_pressed("eat")

	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and parent.speed.x != 0
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and parent.speed.x == 0
