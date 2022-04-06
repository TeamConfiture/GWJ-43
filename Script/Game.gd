extends Node

onready var hud := $HUD

var scene_lvl_000 =  preload("res://Scene/Lvl/lvl_000.tscn")

onready var slime = $Slime
var coins := 0
var current_lvl
var lvl_index: int = 0 

func _ready():
	current_lvl = scene_lvl_000.instance()
	
	add_child(current_lvl)
	
	slime.position = current_lvl.get_node("PlayerStart").position
	slime.do_activate(true)
	


func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		SceneLoader.change_scene("Menu")


func _on_Slime_chaudron_eaten():
	slime.do_activate(false)
	#transition de current_lvl -> chaudron arc en ciel etc...
	remove_child(current_lvl)
	lvl_index+=1
	current_lvl = load("res://Scene/Lvl/lvl_%03d"%lvl_index+".tscn").instance()
	add_child(current_lvl)
	slime.position = current_lvl.get_node("PlayerStart").position
	slime.do_activate(true)
