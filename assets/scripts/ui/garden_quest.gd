class_name GardenQuest extends QuestTemplate

@export var dialog_area: DialogArea

var json_file = FileAccess.open("res://assets/data/quests/garden_quest.json", FileAccess.READ)

func get_dictionary_from_json(json_file) -> Dictionary:
	var json_string = json_file.get_as_text()
	var json_dictionary = JSON.parse_string(json_string)
	return json_dictionary

var scene_text = {}
var selected_text = []
var task_done: bool = false

func _ready():
	if scene_text.is_empty(): #This is loading the specific dialog file for the character
		scene_text = get_dictionary_from_json(json_file)

func quest_progress():
	var current_quest ="quest"+ str(quest_progress_counter)
	select_quest(current_quest)
	show_quest()
	active_task = current_quest
func select_quest(text_key):
	selected_text = scene_text[text_key].duplicate()
func show_quest():
	quest_description = selected_text[0]
	QuestManager.update_quest.emit(quest_name, quest_description)
func compleate_task():
	task_done = true
	if selected_text.size() > 1:
		quest_description = selected_text[1]
		QuestManager.update_quest.emit(quest_name, quest_description)
func next_task():
	task_done = false
	quest_progress_counter += 1
	if quest_progress_counter > scene_text.size():
		quest_progress_counter = 1
	if dialog_area.character == "mr_tuto":
		dialog_area.dialog_key = "quest"+str(quest_progress_counter)
	quest_progress()
func start_quest_dialog(dialog_key, character):
	DialogManager.dialog_opened.emit() #Only for the player to enter into idle animation when the dialog opens
	DialogManager.display_dialog.emit(dialog_key, character)
