extends StaticBody2D

signal activate_btn

var push = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_HeavyButton_body_entered(body):
	if !push && body.state == 2:
		$AnimationPlayer.play("HeavyBtn")
		push = !push
		emit_signal("activate_btn",name)
		


