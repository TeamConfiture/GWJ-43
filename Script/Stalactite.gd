extends StaticBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	print(body.state)
#	if body.state == 3:
#			body.state = 0
	pass
