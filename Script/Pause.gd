extends CanvasLayer

var music_bus = AudioServer.get_bus_index("Music")
var sounds_bus = AudioServer.get_bus_index("SFX")
var pause := false
onready var parchemin = $Parchemin

var key_layout = OS.get_latin_keyboard_variant()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Parchemin/Keyb/Eat/Key.text = gey_key("eat")
	$Parchemin/Keyb/Spit/Key.text = gey_key("spit")
	$Parchemin/Keyb/Left/Key.text = gey_key("left")
	$Parchemin/Keyb/Right/Key.text = gey_key("right")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause = !pause
		get_tree().paused=pause
		parchemin.visible = pause
		AudioServer.set_bus_volume_db(music_bus, 0)
	
		
	if pause:
		if Input.is_action_just_pressed("spit"):
			AudioManager.play_button_normal()
			_on_Resume_pressed()
		
		if Input.is_action_just_pressed("eat"):
			AudioManager.play_button_normal()
			_on_Menu_pressed()


func _on_Menu_pressed():
	get_tree().paused=false
	parchemin.visible = false
	SceneLoader.change_scene("Menu")


func _on_Resume_pressed():
	pause = false
	get_tree().paused=pause
	parchemin.visible = pause
	AudioServer.set_bus_volume_db(music_bus, 0)


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
