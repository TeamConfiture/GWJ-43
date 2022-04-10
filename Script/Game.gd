extends Node

onready var hud := $HUD

var scene_lvl_000 =  preload("res://Scene/Lvl/lvl_002.tscn")


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
