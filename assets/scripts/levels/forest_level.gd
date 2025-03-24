extends LevelManager

func _ready():
	reset_stats()
	LevelManager.reset_stats()
	AudioManager.forest.play()
