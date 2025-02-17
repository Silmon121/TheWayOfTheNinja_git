extends Control

func _ready():
	hide() #Hides the PauseMenu from the start
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		LevelManager.game_paused = !LevelManager.game_paused
		pause_menu()
func pause_menu():
	if !LevelManager.game_paused:
		hide() #Hides PauseMenu
		Engine.time_scale = 1 #Starts time 
	else:
		show() #Shows PauseMenu
		Engine.time_scale = 0 #Stops time
func _on_exit_button_pressed():
	get_tree().quit() #Closes the game
func _on_resume_button_pressed():
	LevelManager.game_paused = false 
	pause_menu()
func _on_btm_button_pressed():
	LevelManager.game_paused = false
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://assets/scenes/ui/menus/main_menu.tscn")
