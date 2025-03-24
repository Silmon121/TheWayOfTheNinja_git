extends LevelManager

func _ready():
	LevelManager.reset_level()
	AudioManager.forest.play()
