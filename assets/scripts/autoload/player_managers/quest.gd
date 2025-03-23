extends Node2D

signal allow_next_level()

@export_group("Config")
@export var quest_name: String
@export_file("*.json") var quest_file: String
@export var dialog_area: DialogArea

var quest_description: String
var quest_progress_counter: int = 1
var active_task: String

var scene_text = {}
var selected_text = []
var text_key: String

var task_done: bool = false

signal update_quest(quest_name, quest_description)

func load_quests():
	var quest_json = FileAccess.open(quest_file, FileAccess.READ)
	if scene_text.is_empty(): #This is loading the specific dialog file for the character
		scene_text = FileManager.get_dictionary_from_json(quest_json)
		
func next_task():
	task_done = false
	quest_progress_counter += 1
	if quest_progress_counter > scene_text.size():
		quest_progress_counter = 1
	if dialog_area.character == "mr_tuto":
		dialog_area.dialog_key = "quest"+str(quest_progress_counter)
	quest_progress()
func quest_progress():
	var current_quest ="quest"+ str(quest_progress_counter)
	select_quest(current_quest)
	show_quest()
	active_task = current_quest
func select_quest(text_key):
	selected_text = scene_text[text_key].duplicate()
func show_quest():
	quest_description = selected_text[0]
	Quest.update_quest.emit(quest_name, quest_description)
func compleate_task():
	task_done = true
	if selected_text.size() > 1:
		quest_description = selected_text[1]
		Quest.update_quest.emit(quest_name, quest_description)
func start_quest_dialog(dialog_key, character):
	DialogManager.dialog_opened.emit() #Only for the player to enter into idle animation when the dialog opens
	DialogManager.display_dialog.emit(dialog_key, character)
