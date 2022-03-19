extends State

const Move_Speed = 0.5
const Stop_Speed = 0.3
const Jump_Acc = 3

var want_jump := false

func _physics_process(delta: float) -> void:
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
		if want_jump:
			parent.speed.y -= Jump_Acc
	else:
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed * parent.MulSpeed + Vector2(0, parent.val), Vector2.UP)

func _process(delta: float) -> void:
	want_jump = Input.is_action_just_pressed("up")
	
	parent.want_eat = Input.is_action_just_pressed("eat")
	
	if parent.state != parent.State.leaf and Input.is_action_just_pressed("test_leaf"):
		parent.anim_playback.travel("normal_to_leaf")

	if parent.state != parent.State.rock and Input.is_action_just_pressed("test_magma"):
		parent.anim_playback.travel("normal_to_rock")

	if parent.state != parent.State.water and Input.is_action_just_pressed("test_water"):
		parent.anim_playback.travel("normal_to_water")

	if parent.state != parent.State.mud and Input.is_action_just_pressed("test_mud"):
		parent.anim_playback.travel("normal_to_mud")
	
	var is_on_floor = parent.is_on_floor()
	
	parent.anim_tree["parameters/conditions/is_jumping"] = want_jump
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor
