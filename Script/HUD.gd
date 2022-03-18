extends CanvasLayer

onready var coin_label := $HBoxCoins/CoinLabel
onready var clover_1 := $HBoxClovers/Clover1
onready var clover_2 := $HBoxClovers/Clover2

var textures = {
	"Green": preload("res://Art/HUD/clovers/clover_green.png"),
	"Red": preload("res://Art/HUD/clovers/clover_red.png"),
	"Blue": preload("res://Art/HUD/clovers/clover_blue.png"),
	"Yellow": preload("res://Art/HUD/clovers/clover_yellow.png")
}

func update_coin(value: int) -> void:
	coin_label.text = " x " + str(value)

func update_clovers(clovers : PoolStringArray) -> void:
	if clovers != null:
		if clovers.size() == 2:
			clover_1.texture = textures.get(clovers[0])
			clover_2.texture = textures.get(clovers[1])
