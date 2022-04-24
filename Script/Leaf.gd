extends State

const Max_Speed = 100
const Move_Speed = 0.5
const Stop_Speed = 0.3

const Hook_Speed_X = 0.05

const Rot_Speed_Max = 0.1
const Rot_Speed = 0.05

enum State{normal = 0, hook}

var state:int

var rot_speed:float

var acc := true

onready var hook = parent.get_node("Hook")
onready var shape = parent.get_node("CollisionShape2D")
onready var shape_hook = parent.get_node("CollisionShapeHook")

func state_enabled(b:bool):
	.state_enabled(b)
	
	state = State.normal
	
	if b:
		hook.hook_enabled(true)

func do_physics_process(delta: float) -> void:
	match(state):
		State.normal:
			if parent.is_on_floor():
				parent.speed.y = parent.Grav
			else:
				parent.speed.y += parent.Grav

			parent.move_and_slide(parent.speed, Vector2.UP)
			
		State.hook:
			shape_hook.shape.b = hook.sprite.position * 0.8
			
			var vert:Vector2 = parent.global_position - hook.hook_origin
			
			var vert_rot = (Vector2.DOWN * vert.length()).rotated(- 0.25)
			
			var bleu:Vector2
			
			if acc:
				var vert_rot_sub = vert.rotated(- parent.Grav * Hook_Speed_X * delta)
				
				var vert_to_vert_rot = vert.angle_to(vert_rot)

				var vert_to_vert_rot_sub = vert.angle_to(vert_rot_sub)
#
				if abs(vert_to_vert_rot_sub) > abs(vert_to_vert_rot):
					bleu = vert_rot - vert
					acc = false
				else:
					bleu = vert_rot_sub - vert
					
			else:
				var vert_rot_sub = vert.rotated(parent.Grav * Hook_Speed_X * delta)
				
				var vert_rot_reflect = vert_rot.reflect(Vector2.DOWN)
				
				var vert_to_vert_rot_reflect = vert.angle_to(vert_rot_reflect)
				
				var vert_to_vert_rot_sub = vert.angle_to(vert_rot_sub)
				
				if abs(vert_to_vert_rot_sub) > abs(vert_to_vert_rot_reflect):
					bleu = vert_rot - vert
					acc = true
				else:
					bleu = vert_rot_sub - vert
			
			parent.label.text = str(acc)
			
#			var vert_angle_to_down = vert.angle_to(Vector2.DOWN)
#
#			parent.label.text = str(vert_angle_to_down)
#
#			var vert_rot:Vector2
#
#			if is_zero_approx(vert_angle_to_down):
#				rot_speed = clamp(rot_speed - parent.speed.x * Hook_Speed_X * delta, -Rot_Speed_Max, Rot_Speed_Max)
#			else:
#				rot_speed = clamp(rot_speed - sign(vert_angle_to_down) * parent.speed.x * Hook_Speed_X * delta, -Rot_Speed_Max, Rot_Speed_Max)
#
#			if parent.dir.x != 0:
#				vert_rot = vert.rotated(rot_speed)
#			else:
#				vert_rot = vert.rotated(- sign(vert_angle_to_down) * rot_speed)
#
#			var bleu = vert_rot - vert
			
#			vert_rot += vert_rot.normalized() * parent.speed.y

			parent.move_and_slide(bleu / delta, Vector2.UP)
			pass

func reset():
	parent.speed.x = -rot_speed * 1/Rot_Speed_Max
	rot_speed = 0
	shape.disabled = false
	shape_hook.disabled = true
	state = State.normal

func do_process(delta: float) -> void:
	match(state):
		State.normal:
			parent.want_eat = Input.is_action_just_pressed("eat")
			
			if parent.dir.x > 0:
				hook.set_right()
			elif parent.dir.x < 0:
				hook.set_left()
			else:
				hook.set_up()
			
			if Input.is_action_just_pressed("up"):
				if hook.launch():
					parent.speed.y = 0
					shape.disabled = true
					shape_hook.disabled = false
					state = State.hook
			
		State.hook:
			parent.dir.y = Input.get_axis("up", "down")
			parent.speed.y = parent.get_speed(parent.dir.y, parent.speed.y)
			
			if Input.is_action_just_pressed("eat"):
				hook.hook_reset()
				reset()

	if Input.is_action_just_pressed("test_normal") \
	or Input.is_action_just_pressed("spit") \
	or parent.normal_to_mud or parent.normal_to_rock or parent.normal_to_steam:
		hook.hook_enabled(false)
		reset()
		parent.anim_playback.travel("spitting")
	
	var is_on_floor = parent.is_on_floor()
	var is_hooking = state == State.hook
	
	parent.anim_tree["parameters/conditions/is_hooking"] = is_hooking
	parent.anim_tree["parameters/conditions/is_on_floor"] = is_on_floor and !is_hooking
	parent.anim_tree["parameters/conditions/is_falling"] = !is_on_floor and !is_hooking
	parent.anim_tree["parameters/conditions/is_moving"] = is_on_floor and parent.dir.x != 0 and !is_hooking
	parent.anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and parent.dir.x == 0 and !is_hooking
