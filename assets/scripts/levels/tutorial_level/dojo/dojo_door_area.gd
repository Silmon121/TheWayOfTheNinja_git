extends Area2D

var insideArea = false
func _on_area_entered(area):
	if(area.name == "HurtBox"):
		insideArea = true
func _on_area_exited(area):
	if(area.name == "HurtBox"):
		insideArea = false
func _input(event):
	if(insideArea and event.is_action_pressed("interact")):
		get_tree().change_scene_to_file("res://assets/scenes/levels/tutorial_level_garden.tscn")
