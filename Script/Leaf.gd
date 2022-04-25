extends State

const Max_Speed = 100
const Move_Speed = 0.5
const Stop_Speed = 0.3

const Rot_Speed_Min = 0.05
const Rot_Speed_Max = 0.15

enum State{normal = 0, hook}

var state:int

var acc := true

var vert_rot:Vector2

var vert_min = Vector2.DOWN.rotated(-0.26)
var vert_max = Vector2.RIGHT.rotated(0.26)
var vert_min_angle_to_vert_max = abs(vert_min.angle_to(vert_max))
var vert_max_angle_to_vert_max_reflect = vert_max.angle_to(vert_max.reflect(Vector2.DOWN))

var rot_speed:float

onready var hook = parent.get_node("Hook")
onready var shape = parent.get_node("CollisionShape2D")
onready var shape_hook = parent.get_node("CollisionShapeHook")
onready var jump_acc = parent.Grav * 20

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
			
			vert_rot = vert_rot.rotated(-parent.speed.x * 0.01 * delta)
			
			var vert_rot_angle_to_vert_min = abs(vert_rot.angle_to(vert_min))
			
			if vert_rot_angle_to_vert_min > vert_min_angle_to_vert_max :
				vert_rot = vert_max * vert_rot.length()

			var vert_rot_angle_to_vert_max = abs(vert_rot.angle_to(vert_max))
			
			if vert_rot_angle_to_vert_max > vert_min_angle_to_vert_max:
				vert_rot = vert_min * vert_rot.length()
			
			var vert_rot_reflect = vert_rot.reflect(Vector2.DOWN)
			
			var vert_rot_angle_to_vert_rot_reflect = vert_rot.angle_to(vert_rot_reflect)
			
			rot_speed = lerp(parent.Grav * Rot_Speed_Min, parent.Grav * Rot_Speed_Max, abs(vert_rot_angle_to_vert_rot_reflect/vert_max_angle_to_vert_max_reflect))
			
			var bleu:Vector2
			
			if acc:
				var vert_to_vert_rot = vert.angle_to(vert_rot)
				
				var vert_rot_sub = vert.rotated(- rot_speed * delta)

				var vert_to_vert_rot_sub = vert.angle_to(vert_rot_sub)
#
				if abs(vert_to_vert_rot_sub) > abs(vert_to_vert_rot):
					bleu = vert_rot - vert
					acc = false
				else:
					bleu = vert_rot_sub - vert
			else:
				var vert_to_vert_rot_reflect = vert.angle_to(vert_rot_reflect)
				
				var vert_rot_sub = vert.rotated(rot_speed * delta)
				
				var vert_to_vert_rot_sub = vert.angle_to(vert_rot_sub)
				
				if abs(vert_to_vert_rot_sub) > abs(vert_to_vert_rot_reflect):
					bleu = vert_rot_reflect - vert
					acc = true
				else:
					bleu = vert_rot_sub - vert
					
			parent.label.text = str(acc)

			parent.move_and_collide(bleu)
			pass

func reset():
	var mul = 1 if acc else -1
	var speed = Vector2(mul * 1.25, -1) * jump_acc
	prints(speed, rot_speed)
	parent.speed = speed
	
	parent.move_and_slide(parent.speed, Vector2.UP)
	
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
					
					var vert:Vector2 = parent.global_position - hook.hook_origin
					
					vert_rot = vert_min * vert.length()
					
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
