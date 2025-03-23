extends Node2D

@export var dialog_key = "" #Key to the json dictionary
@export var character = "" #This is used to determine which json dialog file should be loaded as a scene_text
@export var tutorial_quest: TutorialQuest
# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.reset_level()
	AudioManager.dojo.play()
	await get_tree().create_timer(0.2).timeout
	start_tutorial()
	
func start_tutorial():
	DialogManager.dialog_opened.emit() #Only for the player to enter into idle animation when the dialog opens
	DialogManager.display_dialog.emit(dialog_key, character)
	await get_tree().create_timer(0.1).timeout
	tutorial_quest.quest_progress()
