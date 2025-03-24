extends LevelManager

@export_group("Starting dialog")
@export_file("*.json") var dialog_file: String
@export var dialog_key = "" #Key to the json dictionary
@export var character = "" #This is used to determine which json dialog file should be loaded as a scene_text
@export var tutorial_quest: TutorialQuest
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_stats()
	AudioManager.dojo.play()
	await get_tree().create_timer(0.2).timeout
	start_tutorial()
	
func start_tutorial():
	DialogManager.start_dialog(dialog_file, dialog_key, character)
	tutorial_quest.quest_progress()
