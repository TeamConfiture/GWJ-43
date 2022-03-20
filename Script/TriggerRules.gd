extends Area2D


var page = 1;

func _on_TriggerRules_body_entered(body):
	if page < 7:
		get_node('P'+ str(page)).visible = true
		page += 1


func _on_Quit_pressed():
	if page < 7:
		get_node('P'+ str(page)).visible = false
		page += 1
