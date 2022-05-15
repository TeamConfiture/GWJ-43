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
var chaudron_eat = false
var big_chaudron_eat = false

func _ready():
	

	current_lvl = scene_lvl_000.instance()
	add_child(current_lvl)
	set_camera_limits(current_lvl.get_node("Tile/Navigation2D/TileMap_platform"))
	update_coins(current_lvl)
	
	cinematic()


func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins,nb_coins)


func _on_Slime_chaudron_eaten():
	
	if chaudron_eat == false :
		score_lvl()
		chaudron_eat=true
	else:

		lvl_index+=1
		var s = "res://Scene/Lvl/lvl_%03d"%lvl_index+".tscn"
		
		if big_chaudron_eat == false && ResourceLoader.exists(s):
			#transition out de current_lvl 
			current_lvl.queue_free()

		
		if ResourceLoader.exists(s):
			current_lvl = load(s).instance()
			add_child(current_lvl)
			$HUD/Score.visible=false
			update_coins(current_lvl)
			chaudron_eat=false
			cinematic()

		else :
			
			if big_chaudron_eat == false :
				$HUD/Score/Perfect.visible=false
				$HUD/Score/Do_better.visible=false
				$HUD/Score/Perfect_end.visible=false
				$HUD/Score/Do_better_end.visible=false

				$HUD/Score.visible=true
				nb_coins = 0
				coins = 0
				for i in coins_per_levels.size():
					nb_coins += coins_per_levels[i][0]
					coins += coins_per_levels[i][1]
					$HUD/Score/Scoring.text = str(coins)+" / "+str(nb_coins)

				var ratio = 100 * float(coins) / float(nb_coins)
				
				if ratio == 100 :
					$HUD/Score/Perfect_end.visible=true
				else:
					$HUD/Score/Do_better_end.visible=true
				
				yield(get_tree().create_timer(2), "timeout")
				big_chaudron_eat = true
			else :
				$HUD/Score.visible=false
				SceneLoader.change_scene("Fin")

func score_lvl():
	$HUD/Score/Perfect.visible=false
	$HUD/Score/Do_better.visible=false
	$HUD/Score/Perfect_end.visible=false
	$HUD/Score/Do_better_end.visible=false
	coins_per_levels[lvl_index][1] = coins
	cinematic_done = false
	slime.do_activate(false)
	$HUD/Score.visible=true
	
	var ratio = 100 * float(coins) / float(nb_coins)
	
	var tick
	if coins > 0 :
		tick = 0.25 / coins
	else:
		tick = 0.01

	for i in coins+1:
		$HUD/Score/Scoring.text = str(i)+" / "+str(nb_coins)
		AudioManager.play_Score()
		yield(get_tree().create_timer(tick), "timeout")

	if ratio == 100 :
		$HUD/Score/Perfect.visible=true
	else:
		$HUD/Score/Do_better.visible=true




func update_coins(lvl):
	var node_coins = lvl.get_node("Coins")
	nb_coins = node_coins.get_child_count()
	coins = 0
	coins_per_levels[lvl_index] = [nb_coins, coins]
	hud.update_coin(coins,nb_coins)

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_page_up"):
		_on_Slime_chaudron_eaten()

	if Input.is_action_just_pressed("spit") && chaudron_eat == true :
			_on_Slime_chaudron_eaten()

	if Input.is_action_just_pressed("spit") && big_chaudron_eat == true :
			_on_Slime_chaudron_eaten()
	
	if !path:
			return

	if Input.is_action_just_pressed("spit"):
		cam.position = path[0]  
		path.resize(0) # clear no working....


	if path.size() > 0:
		var d: float = cam.position.distance_to(path[0])
		if d > 100:
			cam.position = cam.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)

	if path.size() < 1:
		
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
	$LvlLoader.to_black()
	yield($LvlLoader/AnimationPlayer,"animation_finished")
	slime.do_activate(true)
	$LvlLoader.to_white()

func _on_cinematic_end():
	$HUD/Space.visible=false

	if cinematic_done == true : # Du coup si cinematique faite on est en mode Door
		emit_signal("open_door")

	else :
		$LvlLoader.to_black()
		yield($LvlLoader/AnimationPlayer,"animation_finished")
		slime.position = slime_position
		slime.do_activate(true)
		$LvlLoader.to_white()
		cinematic_done = true




func set_camera_limits(lvl :TileMap ):
	var map_limits = lvl.get_used_rect()
	var map_cellsize = lvl.cell_size
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_bottom = map_limits.end.y * map_cellsize.y
	
	$Slime/Camera2D.limit_left = cam.limit_left
	$Slime/Camera2D.limit_right = cam.limit_right
	$Slime/Camera2D.limit_top = cam.limit_top
	$Slime/Camera2D.limit_bottom = cam.limit_bottom



