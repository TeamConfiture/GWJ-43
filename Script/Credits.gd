extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("spit"):
		AudioManager.play_button_normal()
		SceneLoader.change_scene("Menu")
