extends State

const Max_Speed = 120 #150
const Move_Speed = 0.5
const Stop_Speed = 0.08 #0.02

func do_transform():
	parent.anim_playback.travel("to_normal")

func do_physics_process(_delta: float) -> void:
	parent.set_collision_mask_bit(2, 0)

	if parent.is_in_water():
		parent.anim_playback.travel("spitting")

	parent.move_and_slide(parent.speed, Vector2.UP)
	
func do_process(_delta: float) -> void:
	parent.dir.y = Input.get_axis("up", "down")
	
	parent.dir = parent.dir.normalized()
	
	parent.speed.y = parent.get_speed(parent.dir.y, parent.speed.y)
	
	parent.want_eat = Input.is_action_just_pressed("eat")
	
	if Input.is_action_just_pressed("spit"):
		parent.anim_playback.travel("spitting")
		
	var tmp_my_is_zero_approx = parent.my_is_zero_approx(parent.speed.x)
	
	parent.anim_tree["parameters/conditions/is_moving"] = !tmp_my_is_zero_approx
	parent.anim_tree["parameters/conditions/is_not_moving"] = tmp_my_is_zero_approx
