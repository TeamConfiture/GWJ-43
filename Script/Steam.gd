extends State

const Move_Speed = 0.5
const Stop_Speed = 0.02

var val = 0
var val_max = -15
var val_acc = val_max*0.075
var val_mode := false

func _physics_process(delta: float) -> void:
	parent.set_collision_mask_bit(2, 0)
	
	if parent.is_in_water():
		parent.anim_playback.travel("spitting")
	
	parent.move_and_slide(parent.speed * parent.MulSpeed, Vector2.UP)
	
func _process(delta: float) -> void:
	val -= -val_acc
			
	if val < val_max:
		val = -val_max
	
	parent.dir.y = Input.get_axis("up", "down")
	
	parent.dir = parent.dir.normalized()
	
	parent.speed.y = parent.get_speed(parent.dir.y, parent.speed.y)
	
	parent.want_eat = Input.is_action_just_pressed("eat")
	
	if Input.is_action_just_pressed("test_normal") \
	or parent.normal_to_leaf or parent.normal_to_mud or parent.normal_to_rock:
		parent.anim_playback.travel("spitting")
