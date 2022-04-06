extends Node




export(String, "Moves","Clover", "Spit", "Steam","Mud","Vine","Block") var rules_index

onready var parchemin =  $CanvasLayer/Parchemin

var dejavu:bool = false


var dic_rules = {
	"Moves": preload("res://Art/Rules/rules_final_1.png"),
	"Clover": preload("res://Art/Rules/rules_final_5.png"), 
	"Spit": preload("res://Art/Rules/rules_final_6.png"), 
	"Steam": preload("res://Art/Rules/rules_final_7.png"), 
	"Mud": preload("res://Art/Rules/rules_final_8.png"),
	"Vine": preload("res://Art/Rules/rules_final_9.png"), 
	"Block": preload("res://Art/Rules/rules_final_10.png") 

	}

func _ready():
	parchemin.texture=dic_rules[rules_index]
	parchemin.visible=false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		parchemin.visible=false

func _on_TriggerRules_body_entered(body):
	
	if dejavu == false :
		if body.name == "Slime" :
			parchemin.visible=true
			dejavu=true



func _on_Quit_pressed():
	parchemin.visible=false
