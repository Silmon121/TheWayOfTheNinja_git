extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.reset_stats()
	AudioManager.main_menu.play()

func _on_button_pressed():
	LevelManager.exit_game()
