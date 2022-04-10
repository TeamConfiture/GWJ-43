extends Node

onready var hud := $HUD

onready var cam = $Camera2D

var nav : Navigation2D
var path : PoolVector2Array
var goal : Vector2
var start : Vector2
export var speed := 250

signal cinematic_end

var scene_lvl_000 =  preload("res://Scene/Lvl/lvl_000.tscn")



onready var slime = $Slime
var coins := 0
var current_lvl
var lvl_index: int = 0 

func _ready():
	current_lvl = scene_lvl_000.instance()
	
	add_child(current_lvl)
	
	set_camera_limits(current_lvl.get_node("Tile/Navigation2D/TileMap_platform"))
	
	slime.position = current_lvl.get_node("PlayerStart").position
	start = slime.position -Vector2(0,80)
	goal = current_lvl.get_node("Chaudron").position
	nav = current_lvl.get_node("Tile/Navigation2D")
	
	path = nav.get_simple_path(start, goal, false)
#	$Line2D.points = PoolVector2Array(path)
#	$Line2D.show()
	cam.position=start
	cam.current=true
	
	
	
#	slime.do_activate(true)



func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)


func _on_Slime_chaudron_eaten():
	slime.do_activate(false)
	#transition out de current_lvl 
	remove_child(current_lvl)
	lvl_index+=1
	var s = "res://Scene/Lvl/lvl_%03d"%lvl_index+".tscn"
	if ResourceLoader.exists(s):
		current_lvl = load(s).instance()
		add_child(current_lvl)
		slime.position = current_lvl.get_node("PlayerStart").position
		#transition in de current_lvl -> chaudron arc en ciel etc...
		#penser à yiel
		slime.do_activate(true)
	else :
		SceneLoader.change_scene("Fin")

func _process(delta: float) -> void:
	if !path:
		
		return
	if path.size() > 0:
		var d: float = $Camera2D.position.distance_to(path[0])
		if d > 10:
			$Camera2D.position = $Camera2D.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)
	if path.size() < 1:
		$LvlLoader.change_lvl_out()
		emit_signal("cinematic_end")
		


func _on_Game_cinematic_end():
	$LvlLoader.change_lvl_in()
	slime.do_activate(true)

func set_camera_limits(lvl :TileMap ):
	var map_limits = lvl.get_used_rect()
	var map_cellsize = lvl.cell_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	
