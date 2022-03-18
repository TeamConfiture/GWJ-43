extends State

const Move_Speed = 0.5
const Stop_Speed = 0.3

onready var hook = parent.get_node("Hook")

func state_enabled(b:bool):
	.state_enabled(b)
	hook.hook_enabled(b)

func _physics_process(delta: float) -> void:
	if parent.is_on_floor():
		parent.speed.y = parent.Grav
	else:
		parent.speed.y += parent.Grav

	parent.move_and_slide(parent.speed * parent.MulSpeed + Vector2(0, parent.val), Vector2.UP)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		hook.launch()

	if Input.is_action_just_pressed("test_normal"):
		parent.anim_playback.travel("to_normal")
