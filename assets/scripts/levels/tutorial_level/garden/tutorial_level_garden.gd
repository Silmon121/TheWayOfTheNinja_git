extends LevelManager

@export_group("Quest")
@export var dialog_key = "" #Key to the json dictionary
@export var character = "" #This is used to determine which json dialog file should be loaded as a scene_text
@export var garden_quest: GardenQuest

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.current_level_path = current_level_path
	reset_stats()
	AudioManager.garden.play()
	garden_quest.quest_progress()
