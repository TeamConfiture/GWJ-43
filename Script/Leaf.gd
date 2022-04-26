extends State

const Max_Grav = 500

const Max_Speed = 100
const Move_Speed = 0.5
const Stop_Speed = 0.3

const Rot_Speed_Min = 0.05
const Rot_Speed_Max = 0.15

const Chain_Pull = 50

enum State{normal = 0, hook}

var state:int

onready var hook = parent.get_node("Hook")
onready var shape = parent.get_node("CollisionShape2D")
onready var shape_hook = parent.get_node("CollisionShapeHook")

func state_enabled(b:bool):
	.state_enabled(b)
	
	state = State.normal
	
	if b:
		hook.hook_enabled(true)

func do_physics_process(delta: float) -> void:
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
	else:
		parent.speed.y = clamp(parent.speed.y + parent.Grav, 0, Max_Grav)

	if state == State.hook:
		shape_hook.shape.b = hook.sprite.position * 0.8

		var chain_velocity:Vector2 = (hook.hook_origin - parent.global_position).normalized() * Chain_Pull

		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(parent.speed.x):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 1
			
		parent.speed += chain_velocity

	parent.move_and_slide(parent.speed, Vector2.UP)

func reset():
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
					shape.disabled = true
					shape_hook.disabled = false
					
					state = State.hook
			
		State.hook:
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
