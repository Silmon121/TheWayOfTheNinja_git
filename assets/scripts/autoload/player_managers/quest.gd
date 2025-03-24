extends Node2D

signal allow_next_level()

@export_group("Quest config")
@export var quest_name: String
@export_file("*.json") var quest_file: String
@export_group("Dialog config")
@export var dialog_area: DialogArea

var quest_description: String
var quest_progress_counter: int = 1
var active_task: String

var scene_text = {}
var selected_text = []
var text_key: String

var task_done: bool = false
var door_opened: bool = false

signal update_quest(quest_name, quest_description)
#Loads the quest set from the json file from the data.
func load_quests(quest_file):
	var quest_json = FileAccess.open(quest_file, FileAccess.READ)
	if scene_text.is_empty(): #This is loading the specific dialog file for the character
		scene_text = FileManager.get_dictionary_from_json(quest_json)
#Activates new quest
func next_task():
	task_done = false
	quest_progress_counter += 1
	#Changing the area's dialog key to ensure that the mr. tuto has new dialog lines.
	if dialog_area.character == "mr_tuto":
		dialog_area.dialog_key = "quest"+str(quest_progress_counter)
	quest_progress()
#The quest will progress
func quest_progress():
	active_task ="quest"+ str(quest_progress_counter)
	select_quest(active_task)
	show_quest()
#Selects the right dialog set from the dictionary
func select_quest(text_key):
	selected_text = scene_text[text_key].duplicate()
#Shows the first line of the dialog set
func show_quest():
	quest_description = selected_text[0]
	Quest.update_quest.emit(quest_name, quest_description)
#Shows the final line of the dialog set
func complete_task():
	task_done = true
	if selected_text.size() > 1:
		quest_description = selected_text[1]
		Quest.update_quest.emit(quest_name, quest_description)

