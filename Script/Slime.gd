extends KinematicBody2D
class_name Slime

signal clover_eaten
signal coin_caught

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree
onready var anim_playback = anim_tree.get("parameters/playback")
onready var area = $Area2D
onready var swim_level = $SwimLevel

const MulSpeed = 100
const Grav = 0.0981

var linear_vel:Vector2

var dir:Vector2

var speed:Vector2

enum State{normal = 0, leaf, rock, steam, mud}

onready var state_dic = {State.normal:$Normal, State.leaf:$Leaf, State.rock:$Rock, State.steam:$Steam, State.mud:$Mud}

var state = State.normal

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
		
		move_speed = node_state.Move_Speed
		stop_speed = node_state.Stop_Speed
		
		node_state.state_enabled(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_state(State.normal)

func get_speed(_dir:float, _speed:float) -> float:
	if _dir != 0:
		return clamp(_speed+_dir*move_speed, -1, 1)
	return sign(_speed)*clamp(abs(_speed)-stop_speed, 0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir.x = Input.get_axis("left", "right")
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
	speed.x = get_speed(dir.x, speed.x)
	
	anim_tree["parameters/conditions/is_eating"] = want_eat

#call from anim_player
func _on_eat() -> void:
	var areas = area.get_overlapping_areas()
	
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
			if clovers[0] == "Green" and clovers[1] == "Blue" \
				or clovers[0] == "Blue" and clovers[1] == "Green":
				not_transform = false
				normal_to_leaf = true
			
			# Red + Blue = Steam
			if clovers[0] == "Red" and clovers[1] == "Blue" \
				or clovers[0] == "Blue" and clovers[1] == "Red":
				not_transform = false
				normal_to_steam = true
			
			# Red + Green = Steam
			if clovers[0] == "Red" and clovers[1] == "Green" \
				or clovers[0] == "Green" and clovers[1] == "Red":
				not_transform = false
				normal_to_steam = true
			
			# Red + Yellow = Rock
			if clovers[0] == "Red" and clovers[1] == "Yellow" \
				or clovers[0] == "Yellow" and clovers[1] == "Red":
				not_transform = false
				normal_to_rock = true
			
			# Green + Yellow = Rock
			if clovers[0] == "Green" and clovers[1] == "Yellow" \
				or clovers[0] == "Yellow" and clovers[1] == "Green":
				not_transform = false
				normal_to_rock = true
			
			# Yellow + Blue = Mud
			if clovers[0] == "Yellow" and clovers[1] == "Blue" \
				or clovers[0] == "Blue" and clovers[1] == "Yellow":
				not_transform = false
				normal_to_mud = true
			
			_area.be_eaten()

func _spit() -> void:
	clovers = ["", ""]
	emit_signal("clover_eaten", clovers)

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
