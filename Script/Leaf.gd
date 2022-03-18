extends State

const Move_Speed = 0.5
const Stop_Speed = 0.3
const Rot_Speed = 1

enum State{normal = 0, hook}

var state:int

onready var hook = parent.get_node("Hook")

func state_enabled(b:bool):
	.state_enabled(b)
	hook.hook_enabled(b)
	state = State.normal

func _physics_process(delta: float) -> void:
	match(state):
		State.normal:
			if parent.is_on_floor():
				parent.speed.y = parent.Grav
			else:
				parent.speed.y += parent.Grav

			parent.move_and_slide(parent.speed * parent.MulSpeed + Vector2(0, parent.val), Vector2.UP)
			
		State.hook:
#			parent.global_position = hook.hook_origin + (parent.global_position - hook.hook_origin).rotated(-Rot_Speed * parent.speed.x)
			
			var vert = parent.global_position - hook.hook_origin
			
			var vert_rot = vert.rotated(parent.speed.x * 2)
			
			var bleu = vert_rot - vert
			
			parent.position += bleu * delta
			
#			var bleu = hook.hook_origin + (parent.global_position - hook.hook_origin).rotated(0) - parent.global_position
#
#			var jaune = Vector2(0, -parent.Grav)
#
#			var vert = (-bleu).project(jaune)
#
#			prints("Leaf", vert)
#
#			parent.move_and_slide(bleu, Vector2.UP)
			pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		match(state):
			State.normal:
				if hook.launch():
					parent.speed.y = 0
					state = State.hook

	if Input.is_action_just_pressed("test_normal"):
		parent.anim_playback.travel("to_normal")
