extends CanvasLayer

onready var coin_icon := $VBoxContainer/HBoxCoins/CoinIcon
onready var coin_label := $VBoxContainer/HBoxCoins/CoinLabel
onready var clover_1 := $VBoxContainer/HBoxClovers/Clover1
onready var clover_2 := $VBoxContainer/HBoxClovers/Clover2

var clover_green : Texture = preload("res://Art/HUD/clover_green.png")
var clover_red : Texture = preload("res://Art/HUD/clover_red.png")
var clover_blue : Texture = preload("res://Art/HUD/clover_blue.png")
var clover_yellow : Texture = preload("res://Art/HUD/clover_yellow.png")

var coins : int = 0 setget set_coin

var textures = {
	"Green": clover_green,
	"Red": clover_red,
	"Blue": clover_blue,
	"Yellow": clover_yellow
}

func set_coin(value: int) -> void:
	coins = value
	coin_label.text = " x " + str(coins)

func update_clovers(clovers : PoolStringArray) -> void:
	if clovers != null:
		if clovers.size() == 2:
			clover_1.texture = textures.get(clovers[0]) if textures.has(clovers[0]) else null
			clover_2.texture = textures.get(clovers[1]) if textures.has(clovers[1]) else null
