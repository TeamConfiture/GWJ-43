extends StaticBody2D


var push = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_HeavyButton_body_entered(body):
	print(body.state)
	if !push && body.state == 2:
		$AnimationPlayer.play("HeavyBtn")
		push = !push
