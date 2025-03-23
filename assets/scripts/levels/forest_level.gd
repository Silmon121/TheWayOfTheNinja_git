extends Node2D

func _ready():
	LevelManager.reset_level()
	AudioManager.forest.play()
