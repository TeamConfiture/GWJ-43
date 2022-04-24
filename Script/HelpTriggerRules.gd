extends Node

export(String, "Moves","Clover", "Spit", "Steam","Mud","Vine","Block") var rules_index

onready var parchemin =  $CanvasLayer/Parchemin

var slime

var dejavu:bool = false

var key_layout = OS.get_latin_keyboard_variant()

var dic_rules_QWERTY = {
	"Moves": preload("res://Art/Rules/rules_final_1.png"),
	"Clover": preload("res://Art/Rules/rules_final_5_Q.png"), 
	"Spit": preload("res://Art/Rules/rules_final_6.png"), 
	"Steam": preload("res://Art/Rules/rules_final_7.png"), 
	"Mud": preload("res://Art/Rules/rules_final_8.png"),
	"Vine": preload("res://Art/Rules/rules_final_9_Q.png"), 
	"Block": preload("res://Art/Rules/rules_final_10.png") 
	}

var dic_rules_AZERTY = {
	"Moves": preload("res://Art/Rules/rules_final_1.png"),
	"Clover": preload("res://Art/Rules/rules_final_5_A.png"), 
	"Spit": preload("res://Art/Rules/rules_final_6.png"), 
	"Steam": preload("res://Art/Rules/rules_final_7.png"), 
	"Mud": preload("res://Art/Rules/rules_final_8.png"),
	"Vine": preload("res://Art/Rules/rules_final_9_A.png"), 
	"Block": preload("res://Art/Rules/rules_final_10.png") 
	}

func _ready():

	if key_layout == "QWERTY" :
		parchemin.texture=dic_rules_QWERTY[rules_index]
	else :
		parchemin.texture=dic_rules_AZERTY[rules_index]
	parchemin.visible=false
	slime = get_tree().get_root().get_node("Game/Slime") 

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		parchemin.visible=false
		slime.do_activate(true)

func _on_TriggerRules_body_entered(body):

	if dejavu == false :
		if body.name == "Slime" :
			slime.do_activate(false)
			parchemin.visible=true
			dejavu=true



func _on_Quit_pressed():
	parchemin.visible=false
	slime.do_activate(true)
