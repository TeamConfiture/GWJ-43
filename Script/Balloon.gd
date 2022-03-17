extends Area2D


onready var anim = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.speed_scale =0.5
	$AnimatedSprite.play("Idle")
	



func _on_Balloon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_doubleclick() :
		$AudioStreamPlayer2D.play(0.0)
		$AnimatedSprite.speed_scale =2
		$AnimatedSprite.play("Balloon")
