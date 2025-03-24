extends Control
func _ready():
	LevelManager.reset_stats()
	AudioManager.main_menu.play()
#Start button pressed
func _on_start_button_pressed():
	LevelManager.next_level("res://assets/scenes/levels/tutorial_level_dojo.tscn")
#Exit button pressed
func _on_exit_button_pressed():
	LevelManager.exit_game()
#Options button pressed
func _on_options_button_pressed():
	LevelManager.next_level("res://assets/scenes/ui/menus/settings.tscn")
