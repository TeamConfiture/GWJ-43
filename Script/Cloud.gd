extends ParallaxLayer


export(float) var Cloud_Speed = -15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta)->void:
	self.motion_offset.x += Cloud_Speed * delta


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		print("brouaaaaaaaaaaaaa")
