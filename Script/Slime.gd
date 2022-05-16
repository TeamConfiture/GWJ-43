extends KinematicBody2D
class_name Slime

signal clover_eaten
signal coin_caught
signal chaudron_eaten

const Grav = 9.81

const Dont_Move_States = ["eating", "normal_to_leaf", "normal_to_rock", "normal_to_steam", "normal_to_mud", "to_normal", "spitting"]

const approx_epsilon = 0.75

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree
onready var anim_playback = anim_tree.get("parameters/playback")
onready var node_area = $Area2D
onready var swim_level = $SwimLevel

var linear_vel:Vector2

var dir:Vector2

var speed:Vector2

enum State{normal = 0, leaf, rock, steam, mud}

onready var state_dic = {State.normal:$Normal, State.leaf:$Leaf, State.rock:$Rock, State.steam:$Steam, State.mud:$Mud}

var state = State.normal

var max_speed:float
var move_speed:float
var stop_speed:float

var is_falling := true

var want_eat := false

var clovers = ["", ""]

var not_transform := true
var normal_to_leaf := false
var normal_to_mud := false
var normal_to_rock := false
var normal_to_steam := false

func _set_state(new_state:int):
	state_dic[state].state_enabled(false)
	
	if state_dic.has(new_state):
		state = new_state
		
		var node_state = state_dic[state]
		
		max_speed = node_state.Max_Speed
		move_speed = node_state.Move_Speed
		stop_speed = node_state.Stop_Speed
		
		node_state.state_enabled(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_state(State.normal)
	set_camera_limits()
	set_process(false)
	set_physics_process(false)

func lvl_state(new_state:int):
	if new_state != state :
		not_transform = false
		match new_state:
			0:
				anim_playback.travel("spitting")
			1:
				normal_to_leaf = true
			2:
				normal_to_rock = true
			3:
				normal_to_steam = true
			4: 
				normal_to_mud = true
				
		state_dic[state].do_transform()

func do_activate(etat:bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !etat)
	visible=true #etat
	set_process(etat)
	set_physics_process(etat)
	$Camera2D.current=true
	
func get_speed(_dir:float, _speed:float) -> float:
	if _dir != 0 and !(anim_playback.get_current_node() in Dont_Move_States):
		return lerp(_speed, sign(_dir) * max_speed, move_speed)
	return lerp(_speed, 0, stop_speed)

func my_is_zero_approx(f:float):
	return round(f) == 0

func _physics_process(delta: float) -> void:
	state_dic[state].do_physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir.x = Input.get_axis("left", "right")
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
	
	speed.x = get_speed(dir.x, speed.x)
	
	state_dic[state].do_process(delta)
	
	anim_tree["parameters/conditions/is_eating"] = want_eat

func check_clover(cloverA:String, cloverB:String) -> bool:
	if (clovers[0] == cloverA and clovers[1] == cloverB) or \
		(clovers[0] == cloverB and clovers[1] == cloverA):
		return true
	return false

#call from anim_player
func _on_eat() -> void:
	var areas = node_area.get_overlapping_areas()
	
	for _area in areas:
		if _area.is_in_group("Clover"):
			clovers[0] = clovers[1]
			clovers[1] = _area.clover_type
			
			emit_signal("clover_eaten", clovers)
			
			not_transform = true
			normal_to_leaf = false
			normal_to_mud = false
			normal_to_rock = false
			normal_to_steam = false
			
			# Green + Blue = Leaf
			if state != State.leaf and check_clover("Green", "Blue"):
				not_transform = false
				normal_to_leaf = true
			
			# Red + Blue = Steam
			if state != State.steam and check_clover("Red", "Blue"):
				not_transform = false
				normal_to_steam = true
			
			# Red + Yellow = Rock
			if state != State.rock and check_clover("Red", "Yellow"):
				not_transform = false
				normal_to_rock = true
			
			# Yellow + Blue = Mud
			if state != State.mud and check_clover("Yellow", "Blue"):
				not_transform = false
				normal_to_mud = true
			
			_area.be_eaten()
			
			if !not_transform:
				state_dic[state].do_transform()
		
		if _area.is_in_group("Chaudron"):
			emit_signal("chaudron_eaten")
			pass
			

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		$Collect.play(0.0)
		emit_signal("coin_caught")
		area.queue_free()

const WATER_MASK = 1 << 2

func is_in_water():
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(swim_level.global_position, 1, [], WATER_MASK)
	return results.size() != 0


func set_camera_limits():
#	$Camera2D.limit_right = get_viewport().size.x
#	$Camera2D.limit_bottom = get_viewport().size.y
	pass

func get_audio_node_from_state(node_name:String):
	var node_audio = state_dic[state].get_node_or_null(node_name)
	
	if !node_audio:
		node_audio = get_node_or_null(node_name)
		
	return node_audio

func play_audio_node_from_state(node_name:String):
	var node_audio = get_audio_node_from_state(node_name)

	if node_audio:
		node_audio.play()
		
func stop_audio_node_from_state(node_name:String):
	var node_audio = get_audio_node_from_state(node_name)

	if node_audio:
		node_audio.stop()

## called from states
func _on_start_landing():
	play_audio_node_from_state("Character_Landing")
	
	if state == State.rock:
		$Camera2D.shake(100,0.4,100)

## called by animations
func _on_start_idle():
	stop_audio_node_from_state("Character_Falling")
	stop_audio_node_from_state("Character_Walking")

func _on_start_walking():
	play_audio_node_from_state("Character_Walking")

func _on_start_jumping():
	play_audio_node_from_state("Character_Jumping")

func _on_start_falling():
	play_audio_node_from_state("Character_Falling")

func _on_start_eating():
	speed = Vector2.ZERO
	
	play_audio_node_from_state("Character_Eating")

func _on_start_transforming():
	speed = Vector2.ZERO
	
	play_audio_node_from_state("Character_Transform")

func _on_start_spitting():
	speed = Vector2.ZERO
	
	play_audio_node_from_state("Character_Spitting")
	
	clovers = ["", ""]
	
	emit_signal("clover_eaten", clovers)
