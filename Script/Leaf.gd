extends State

const Move_Speed = 0.5
const Stop_Speed = 0.3

const Hook_Speed_X = 0.01

const Rot_Speed_Max = 0.05
const Rot_Speed = 0.05

enum State{normal = 0, hook}

var state:int

var rot_speed:float

onready var hook = parent.get_node("Hook")

func state_enabled(b:bool):
	.state_enabled(b)
	
	state = State.normal
	
	if b:
		hook.hook_enabled(true)

func _physics_process(delta: float) -> void:
	match(state):
		State.normal:
			if parent.is_on_floor():
				parent.speed.y = parent.Grav
			else:
				parent.speed.y += parent.Grav

			parent.move_and_slide(parent.speed * parent.MulSpeed + Vector2(0, parent.val), Vector2.UP)
			
		State.hook:
			var vert = (parent.global_position - hook.hook_origin)
			
			var vert_angle_to_down = vert.angle_to(Vector2.DOWN)
			
			rot_speed = clamp(rot_speed + ((parent.speed.x * Hook_Speed_X - vert_angle_to_down * Rot_Speed) * delta), -Rot_Speed_Max, Rot_Speed_Max)
			
			var vert_rot = vert.rotated(rot_speed)
			
			vert_rot -= vert_rot.normalized() * parent.speed.y
			
			var bleu = vert_rot - vert
#
			var jaune = Vector2(0, -parent.speed.y)
			
			var vert_plan = vert_rot.rotated(PI/2)
			
			if jaune.normalized().dot(vert_plan) > 0:
				vert_plan = -vert_plan
			
			var jaune_project = jaune.project(vert_plan)

			parent.move_and_slide(-bleu / delta, Vector2.UP)
			pass

func _process(delta: float) -> void:
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
					state = State.hook
			
	if state == State.hook:
		parent.dir.y = Input.get_axis("up", "down")
		parent.speed.y = parent.get_speed(parent.dir.y, parent.speed.y)
		
		if Input.is_action_just_pressed("eat"):
			hook.hook_reset()
			state = State.normal

	if Input.is_action_just_pressed("test_normal"):
		hook.hook_enabled(false)
		parent.anim_playback.travel("to_normal")
