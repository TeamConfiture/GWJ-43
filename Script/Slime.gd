extends KinematicBody2D
class_name Slime

signal clover_eaten
signal coin_caught

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree
onready var anim_playback = anim_tree.get("parameters/playback")
onready var area = $Area2D

var normal_state_machine := preload("res://Art/StateMachine/StateMachineNormal.tres")
var leaf_state_machine := preload("res://Art/StateMachine/StateMachineLeaf.tres")
var magma_state_machine := preload("res://Art/StateMachine/StateMachineMagma.tres")
var water_state_machine := preload("res://Art/StateMachine/StateMachineWater.tres")
var mud_state_machine := preload("res://Art/StateMachine/StateMachineMud.tres")

const MulSpeed = 100
const Normal_Move_Speed = 0.5
const Normal_Stop_Speed = 0.3
const Steam_Stop_Speed = 0.02
const Grav = 0.0981
const Jump_Acc = 2.5

var linear_vel:Vector2

var dir:Vector2

var speed:Vector2

var want_jump := false

enum State{normal = 0, leaf, magma, water, mud}

var state = State.normal

var move_speed = Normal_Move_Speed

var stop_speed = Normal_Stop_Speed

var val = 0
var val_max = -15
var val_acc = val_max*0.075
var val_mode := false

var is_falling := true

var want_eat := false

var clovers = ["", ""]

var not_transform := true
var normal_to_steam := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func get_speed(_dir:float, _speed:float) -> float:
	if _dir != 0:
		return clamp(_speed+_dir*move_speed, -1, 1)
	return sign(_speed)*clamp(abs(_speed)-stop_speed, 0, 1)

func _physics_process(delta: float) -> void:
	match(state):
		State.normal:
			if is_on_floor():
				speed.y = Grav
				if is_falling:
					is_falling = false
				if want_jump:
					speed.y -= Jump_Acc
			else:
				if !is_falling:
					is_falling = true
				speed.y += Grav
#				sprite.animation = "normal_falling"
	
	move_and_slide(speed * MulSpeed + Vector2(0, val), Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Fleur":
			print("Collided with: ", collision.collider.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir.x = Input.get_axis("left", "right")
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
	speed.x = get_speed(dir.x, speed.x)
	
	match(state):
		State.normal:
			want_jump = Input.is_action_just_pressed("up")
			
			want_eat = Input.is_action_just_pressed("eat")

			if state != State.leaf and Input.is_action_just_pressed("test_leaf"):
				anim_playback.travel("normal_to_leaf")

			if state != State.magma and Input.is_action_just_pressed("test_magma"):
				anim_playback.travel("normal_to_magma")

			if state != State.water and Input.is_action_just_pressed("test_water"):
				anim_playback.travel("normal_to_water")

			if state != State.mud and Input.is_action_just_pressed("test_mud"):
				anim_playback.travel("normal_to_mud")

		State.water:
			val -= -val_acc
			
			if val < val_max:
				val = -val_max
			
			dir.y = Input.get_axis("up", "down")
			
			dir = dir.normalized()
			
			speed.y = get_speed(dir.y, speed.y)

	var is_on_floor = is_on_floor()
	
	if state != State.normal and Input.is_action_just_pressed("test_normal"):
		anim_playback.travel("to_normal")

	anim_tree["parameters/conditions/is_jumping"] = want_jump
	anim_tree["parameters/conditions/is_eating"] = want_eat
	anim_tree["parameters/conditions/is_on_floor"] = is_on_floor
	anim_tree["parameters/conditions/is_falling"] = is_falling
	anim_tree["parameters/conditions/is_moving"] = is_on_floor and speed.x != 0
	anim_tree["parameters/conditions/is_not_moving"] = is_on_floor and speed.x == 0

#call from anim_player
func _on_eat() -> void:
	var areas = area.get_overlapping_areas()
				
	for _area in areas:
		if _area.is_in_group("Clover"):
			clovers[0] = clovers[1]
			clovers[1] = _area.clover_type
			
			emit_signal("clover_eaten", clovers)
			
			not_transform = true
			normal_to_steam = false
			
			if clovers[0] == "Red" and clovers[1] == "Blue" \
				or clovers[0] == "Blue" and clovers[1] == "Red":
				state = State.water
				not_transform = false
				normal_to_steam = true
			
			_area.queue_free()

func _set_state(new_state:int):
	state = new_state

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		emit_signal("coin_caught")
		area.queue_free()
