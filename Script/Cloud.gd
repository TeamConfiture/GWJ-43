extends ParallaxLayer


export(float) var Cloud_Speed = -15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta)->void:
	self.motion_offset.x += Cloud_Speed * delta

