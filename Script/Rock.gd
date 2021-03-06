extends State

const Max_Speed = 75 #50
const Move_Speed = 0.5
const Stop_Speed = 0.3

var in_the_air := true

func do_transform():
	parent.anim_playback.travel("to_normal")

func do_physics_process(_delta: float) -> void:
	parent.set_collision_mask_bit(2, 0)
	if parent.is_on_floor():
		if in_the_air:
			parent._on_start_landing()
			in_the_air = false
		
		parent.speed.y = parent.Grav
	else:
		if !in_the_air:
			in_the_air = true
		
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed, Vector2.UP)

func do_process(_delta: float) -> void:
	if Input.is_action_just_pressed("spit"):
		parent.anim_playback.travel("spitting")

	parent.want_eat = Input.is_action_just_pressed("eat")

	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and !is_zero_approx(parent.speed.x)
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and is_zero_approx(parent.speed.x)
