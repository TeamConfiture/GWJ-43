extends State

const Move_Speed = 0.5
const Stop_Speed = 0.3

func _physics_process(delta: float) -> void:
	parent.set_collision_mask_bit(2, 0)
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
	else:
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed * parent.MulSpeed, Vector2.UP)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_normal") \
	or parent.normal_to_leaf or parent.normal_to_mud or parent.normal_to_steam:
		parent.anim_playback.travel("spitting")

	parent.want_eat = Input.is_action_just_pressed("eat")

	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and parent.speed.x != 0
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and parent.speed.x == 0
