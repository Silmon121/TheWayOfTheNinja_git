extends Control

func _ready():
	hide() #Hides the PauseMenu from the start
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == false:
			show_menu()
		else:
			hide_menu()
func _on_exit_button_pressed():
	LevelManager.exit_game()
func _on_resume_button_pressed():
	hide_menu()
func _on_btm_button_pressed():
	hide_menu()
	get_tree().change_scene_to_file("res://assets/scenes/ui/menus/main_menu.tscn")
func show_menu():
	LevelManager.pause_game()
	show()
func hide_menu():
	LevelManager.resume_game()
	hide()
