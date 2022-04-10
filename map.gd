extends Node2D

onready var nav : Navigation2D = $Navigation2D

var path : PoolVector2Array
var goal : Vector2
export var speed := 500




func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			goal = event.position
			path = nav.get_simple_path($Navigation2D/Light2D.position, goal, false)
			printt (path)
			$Navigation2D/Line2D.points = PoolVector2Array(path)
			$Navigation2D/Line2D.show()
			
func _process(delta: float) -> void:
	if !path:
		$Navigation2D/Line2D.hide()
		return
	if path.size() > 0:
		var d: float = $Navigation2D/Light2D.position.distance_to(path[0])
		if d > 10:
			$Navigation2D/Light2D.position = $Navigation2D/Light2D.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)



