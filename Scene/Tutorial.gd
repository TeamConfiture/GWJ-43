extends Node2D


func _on_Btn1_activate_btn():
	get_node("Door1").find_node("AnimationPlayer").play("porte")


func _on_Btn2_activate_btn():
	get_node("Door2").find_node("AnimationPlayer").play("porte")


func _on_Btn3_activate_btn():
	get_node("Door3").find_node("AnimationPlayer").play("porte")
