extends Node

signal open_door
onready var hud := $HUD

onready var cam = $Camera2D

var nav : Navigation2D
var path : PoolVector2Array
var goal : Vector2
var start : Vector2
export var speed := 250


var scene_lvl_000 =  preload("res://Scene/Lvl/lvl_000.tscn")


onready var slime = $Slime
var slime_position

var state
var coins := 0
var current_lvl
var lvl_index: int = 0 

var nb_coins
var coins_per_levels : Dictionary

var cinematic_done = false

func _ready():
	
	gey_key("eat")

	current_lvl = scene_lvl_000.instance()
	add_child(current_lvl)
	set_camera_limits(current_lvl.get_node("Tile/Navigation2D/TileMap_platform"))
	update_coins(current_lvl)
	
	cinematic()

func gey_key(action:String):
	var key_layout = OS.get_latin_keyboard_variant()
	var list = InputMap.get_action_list(action)

	for a in list:
		if a is InputEventKey:
			var key = OS.get_scancode_string(a.physical_scancode)
			if key_layout == "AZERTY" :
				match key:
					"Q":
						key="A"
					"w":
						key="Z"
				
			print (a,key)
		if a is InputEventJoypadButton:
			prints (a," -> ",Input.get_joy_button_string(a.button_index))
		if a is InputEventJoypadMotion:
			prints (a," -> ",Input.get_joy_axis_string(a.axis))



func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins,nb_coins)


func _on_Slime_chaudron_eaten():
	coins_per_levels[lvl_index][1] = coins
	cinematic_done = false
	slime.do_activate(false)
	$HUD/Score.visible=true
	for i in coins+1:
		$HUD/Score/Label.text = str(i)+" / "+str(nb_coins)
		$Slime/Collect.play(0.0)
		yield(get_tree().create_timer(0.2), "timeout")
		
	yield(get_tree().create_timer(1.0), "timeout")
	#transition out de current_lvl 
	remove_child(current_lvl)

	
	lvl_index+=1
	var s = "res://Scene/Lvl/lvl_%03d"%lvl_index+".tscn"
	if ResourceLoader.exists(s):
		current_lvl = load(s).instance()
		add_child(current_lvl)

		$HUD/Score.visible=false

		update_coins(current_lvl)

		cinematic()

	else :
		
		$HUD/Score.visible=true
		nb_coins = 0
		coins = 0
		for i in coins_per_levels.size():
			print(i)
			nb_coins += coins_per_levels[i][0]
			coins += coins_per_levels[i][1]
			$HUD/Score/Label.text = str(coins)+" / "+str(nb_coins)
			$Slime/Collect.play(0.0)
			yield(get_tree().create_timer(0.1), "timeout")
		yield(get_tree().create_timer(3.0), "timeout")
		$HUD/Score.visible=false
		SceneLoader.change_scene("Fin")

func update_coins(lvl):
	var node_coins = lvl.get_node("Coins")
	nb_coins = node_coins.get_child_count()
	coins = 0
	coins_per_levels[lvl_index] = [nb_coins, coins]
	hud.update_coin(coins,nb_coins)
	
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_page_up"):
		_on_Slime_chaudron_eaten()
	
	if !path:
		return

	if Input.is_action_just_pressed("ui_select"):
		cam.position = path[0]
		path.resize(0) # clear no working....


	if path.size() > 0:
		var d: float = cam.position.distance_to(path[0])
		if d > 100:
			cam.position = cam.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)
	
	if path.size() < 1:
		$LvlLoader.to_black()
		yield($LvlLoader/AnimationPlayer,"animation_finished")
		_on_cinematic_end()

	



func cinematic():
	
	$HUD/Space.visible=true
	state = current_lvl.get_node("PlayerStart").Slime_type
	slime.lvl_state(state)
	set_camera_limits(current_lvl.get_node("Tile/Navigation2D/TileMap_platform"))
	slime_position = current_lvl.get_node("PlayerStart").position
	start = slime_position -Vector2(0,80)
	goal = current_lvl.get_node("Chaudron").position
	nav = current_lvl.get_node("Tile/Navigation2D")
	path = nav.get_simple_path(start, goal, false)
	cam.position = start
	cam.current = true




func find_the_wayout(position_door:Vector2):
	$HUD/Space.visible=true
	cam.smoothing_enabled = false
	slime.do_activate(false)
	start = slime.position
	cam.position=start
	goal = position_door
	nav = current_lvl.get_node("Tile/Navigation2D")
	path = nav.get_simple_path(start, goal, false)
	cam.current = true
	cam.smoothing_enabled = true




func _on_door_open():
	slime.do_activate(true)

func _on_cinematic_end():
	$HUD/Space.visible=false
	if cinematic_done == true : # Du coup si cinematique faite on est en mode Door
		emit_signal("open_door")

	else :
		$LvlLoader.to_white()
		slime.position = slime_position
		slime.do_activate(true)
		cinematic_done = true



func set_camera_limits(lvl :TileMap ):
	var map_limits = lvl.get_used_rect()
	var map_cellsize = lvl.cell_size
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_bottom = map_limits.end.y * map_cellsize.y


