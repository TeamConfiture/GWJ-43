extends Node

export(String, "Moves","Eat", "Spit", "Steam","Mud","Vine","Block") var rules_index

onready var parchemin =  $CanvasLayer/Parchemin


var slime
var illustration

var dejavu:bool = false

var key_layout = OS.get_latin_keyboard_variant()


var dic_titre = {
	"Move": "Moves",
	"Eat": "Eat Clovers", 
	"Spit": "Spit clovers", 
	"Steam": "I Believe I Can Fly", 
	"Mud": "Mud",
	"Vine": "Vine", 
	"Block": "I'm a Rock Star"
}

var dic_P1 = {
	"Move": "",
	"Eat": "Clovers are edible, eating them can give you elemental powers.\n\n\n\n\nFire, water, plant and rock clovers can be combined to get those special forms !", 
	"Spit": "If you don't need a transformation anymore, you can spit the clovers\n\nit can be useful if you get stuck somewhere unusual...", 
	"Steam": "Steam slime can fly though the level, and through the grids too.\n\nBut be careful steam [u]cannot[/u] swim!", 
	"Mud": "Mud slime is fast, loves grids, but cannot jump....\n\n [u]Be careful![/u]\nMud does not like water...",
	"Vine": "Vine slime can go through the level by summoning cute ivy platforms.", 
	"Block": "Block Slime is very heavy, so the buttons activate under its weight.\n He can dive, but cannot get back to land in this form."
}


func _ready():

	if key_layout == "QWERTY" :
		pass
	else :
		pass
	
	parchemin.visible=false
	$CanvasLayer/Parchemin/Titre.text=dic_titre[rules_index]
	$CanvasLayer/Parchemin/P1.bbcode_text=dic_P1[rules_index]
	
	illustration(rules_index,true) 

	slime = get_tree().get_root().get_node("Game/Slime") 


func illustration(rule:String,etat:bool):
	

	
	match rule:

		"Eat":
			$CanvasLayer/Parchemin/Parchemin_BG/eat.visible=etat
			$CanvasLayer/Parchemin/Mud.visible=etat
			$CanvasLayer/Parchemin/Rock.visible=etat
			$CanvasLayer/Parchemin/Vapor.visible=etat
			$CanvasLayer/Parchemin/Vine.visible=etat
		"Spit":
			$CanvasLayer/Parchemin/Parchemin_BG/spit.visible=etat
		"Steam":
			$CanvasLayer/Parchemin/Parchemin_BG/steam.visible=etat
		"Mud":
			$CanvasLayer/Parchemin/Parchemin_BG/mud.visible=etat
		"Vine":
			$CanvasLayer/Parchemin/Parchemin_BG/vine.visible=etat
		"Block":
			$CanvasLayer/Parchemin/Parchemin_BG/rock1.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/rock2.visible=etat



func _process(delta):
	
	
	if Input.is_action_just_pressed("ui_accept"):
		parchemin.visible=false
		illustration(rules_index,false) 
		slime.do_activate(true)
	

func _on_TriggerRules_body_entered(body):

	if dejavu == false :
		if body.name == "Slime" :
			slime.do_activate(false)
			illustration(rules_index,true) 
			parchemin.visible=true
			dejavu=true



func _on_Quit_pressed():
	parchemin.visible=false
	illustration(rules_index,false) 
	slime.do_activate(true)
