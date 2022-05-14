extends CanvasLayer

var music_bus = AudioServer.get_bus_index("Music")
var sounds_bus = AudioServer.get_bus_index("SFX")
var pause := false
onready var parchemin = $Parchemin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause = !pause
		get_tree().paused=pause
		parchemin.visible = pause
		AudioServer.set_bus_volume_db(music_bus, 0)


func _on_Menu_pressed():
	get_tree().paused=false
	parchemin.visible = false
	SceneLoader.change_scene("Menu")


func _on_Resume_pressed():
	pause = false
	get_tree().paused=pause
	parchemin.visible = pause
	AudioServer.set_bus_volume_db(music_bus, 0)
