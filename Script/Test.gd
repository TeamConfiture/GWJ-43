extends Node

onready var hud := $HUD



var coins := 0

func _on_Slime_clover_eaten(clovers: PoolStringArray) -> void:
	hud.update_clovers(clovers)

func _on_Slime_coin_caught() -> void:
	coins += 1
	hud.update_coin(coins)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$HUD/TransitionColor/AnimationPlayer.play("transition_out")
		SceneLoader.load_menu()


func _ready():
	$HUD/TransitionColor/AnimationPlayer.play("transition_in")
