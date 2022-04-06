extends Node

onready var hud := $HUD

var LvlScene =  preload("res://Scene/Lvl/lvl_000.tscn")

var coins := 0


func _ready():
	var lvl = LvlScene.instance()
	add_child(lvl)


func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		SceneLoader.change_scene("Menu")




