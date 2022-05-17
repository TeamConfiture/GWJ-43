extends Node

export(String, "Move","Eat", "Spit", "Steam","Mud","Vine","Block","Combinaisons") var rules_index

onready var parchemin =  $CanvasLayer/Parchemin

var slime

var music_bus = AudioServer.get_bus_index("Music")
var ambiant_bus = AudioServer.get_bus_index("Amb")
var dejavu:bool = false

var key_layout = OS.get_latin_keyboard_variant()


var dic_titre = {
	"Move": "Moves & Actions",
	"Eat": "Eat Clovers", 
	"Spit": "Spit clovers", 
	"Steam": "I Believe I Can Fly", 
	"Mud": "Mud",
	"Vine": "Vine", 
	"Block": "I'm a Rock Star",
	"Combinaisons":"Slime suits"
}

var dic_P1 = {
	"Move": "How do I get there?",
	"Eat": "Clovers are edible, eating them can give you elemental powers.", 
	"Spit": "If you don't need a transformation anymore, you can spit the clovers\nIt can be useful if you get stuck somewhere unusual...", 
	"Steam": "Steam slime can fly though the level, and through the grids too.\n\nBut be careful steam [u]cannot[/u] swim!", 
	"Mud": "Mud slime is fast, loves grids, but cannot jump....\n\n [u]Be careful![/u]\nMud does not like water...",
	"Vine": "Vine slime can go through the level by summoning cute ivy platforms with limited duration when is jumping.", 
	"Block": "Block Slime is very heavy, so the buttons activate under its weight.\n He can dive, but cannot get back to land in this form.",
	"Combinaisons":"Fire, water, plant and rock clovers can be combined to get those special forms !"
}


func _ready():


	parchemin.visible=false
	$CanvasLayer/Parchemin/Titre.text=dic_titre[rules_index]
	$CanvasLayer/Parchemin/P1.bbcode_text=dic_P1[rules_index]

	illustration(rules_index,true) 

	slime = get_tree().get_root().get_node("Game/Slime") 


func illustration(rule:String,etat:bool):

	match rule:

		"Move":
			$CanvasLayer/Parchemin/Pad.visible=etat
			$CanvasLayer/Parchemin/Keyb.visible=etat
			$CanvasLayer/Parchemin/Keyb/Eat/Key.text = gey_key("eat")
			$CanvasLayer/Parchemin/Keyb/Spit/Key.text = gey_key("spit")
			$CanvasLayer/Parchemin/Keyb/Left/Key.text = gey_key("left")
			$CanvasLayer/Parchemin/Keyb/Right/Key.text = gey_key("right")

		"Eat":
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BB.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BD.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG/Action2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG/Arrow2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/eat.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Action.text = "Eat"
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Key.text = gey_key("eat")
			$CanvasLayer/Parchemin/Parchemin_BG/Button.visible=etat

		"Spit":
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BB.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BD/Action4.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BD/Arrow4.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/spit.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Action.text = "Spit"
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Key.text = gey_key("spit")
			$CanvasLayer/Parchemin/Parchemin_BG/Button.visible=etat

		"Steam":
			$CanvasLayer/Parchemin/Parchemin_BG/steam.visible=etat

		"Mud":
			$CanvasLayer/Parchemin/Parchemin_BG/mud.visible=etat

		"Vine":
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BB.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BD.modulate=Color(1,1,1,0.39)
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG/Action2.text = "Ivy"
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG/Action2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Pad2/BG/Arrow2.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/vine.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/yvy.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Action.text = "Ivy"
			$CanvasLayer/Parchemin/Parchemin_BG/Button/Key.text = gey_key("eat")
			$CanvasLayer/Parchemin/Parchemin_BG/Button.visible=etat


		"Block":
			$CanvasLayer/Parchemin/Parchemin_BG/rock1.visible=etat
			$CanvasLayer/Parchemin/Parchemin_BG/rock2.visible=etat

		"Combinaisons":
			$CanvasLayer/Parchemin/Mud.visible=etat
			$CanvasLayer/Parchemin/Rock.visible=etat
			$CanvasLayer/Parchemin/Vapor.visible=etat
			$CanvasLayer/Parchemin/Vine.visible=etat


func gey_key(action:String):

	var list = InputMap.get_action_list(action)

	for a in list:
		if a is InputEventKey:

			var key = OS.get_scancode_string(a.physical_scancode)

			if key == "Left":
				continue
			if key =="Right" :
				continue

			if key_layout == "AZERTY" :
				match key:
					"Q":
						key="A"
					"w":
						key="Z"
					"A":
						key="Q"
					"Z":
						key="W"
			return key


func _process(_delta):

	if Input.is_action_just_pressed("spit"):
		parchemin.visible=false
		illustration(rules_index,false) 
		slime.do_activate(true)
		AudioServer.set_bus_volume_db(music_bus, 0)
		AudioServer.set_bus_volume_db(ambiant_bus, 0)

func _on_TriggerRules_body_entered(body):

	if dejavu == false :
		if body.name == "Slime" :
			slime.do_activate(false)
			illustration(rules_index,true) 
			parchemin.visible=true
			dejavu=true
			AudioServer.set_bus_volume_db(music_bus, -6)
			AudioServer.set_bus_volume_db(ambiant_bus, -6)

func _on_Quit_pressed():
	parchemin.visible=false
	illustration(rules_index,false) 
	slime.do_activate(true)
	AudioServer.set_bus_volume_db(music_bus, 0)
	AudioServer.set_bus_volume_db(ambiant_bus, 0)
