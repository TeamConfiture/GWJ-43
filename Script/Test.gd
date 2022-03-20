extends Node

onready var hud := $HUD

var coins := 0


func _ready():
	set_camera_limits()

func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Scene/Menu.tscn")


func set_camera_limits():
	var map_limits = $lvl/TileMap_limit.get_used_rect()
	var map_cellsize = $lvl/TileMap_limit.cell_size

#	$Slime/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#	$Slime/Camera2D.limit_left = map_limits.position.x * map_cellsize.x

	$Slime/Camera2D.limit_right = map_limits.end.x * map_cellsize.x - 64
	$Slime/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y - 64
