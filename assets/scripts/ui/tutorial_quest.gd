class_name TutorialQuest extends QuestTemplate

@export var dialog_area: DialogArea
@onready var exit_door_anim = %Door

var tutorial_quest_json = FileAccess.open("res://assets/data/quests/tutorial_quest.json", FileAccess.READ)

func get_dictionary_from_json(json_file) -> Dictionary:
	var json_string = json_file.get_as_text()
	var json_dictionary = JSON.parse_string(json_string)
	return json_dictionary
	
var text_key: String
var scene_text = {}
var selected_text = []
var task_done: bool = false
var door_opened: bool = false

func _ready():
	if scene_text.is_empty(): #This is loading the specific dialog file for the character
		scene_text = get_dictionary_from_json(tutorial_quest_json)
func _process(delta):
	if dialog_area.character == "mr_tuto" and dialog_area.area_active == true:
		if active_task == "quest1":
			next_task()
			start_quest_dialog("quest2", "mr_tuto")
			#Prevents activating area twice
			dialog_area.area_active = false
			dialog_area.hide_button()
	if DamageNumbers.player_attacked_enemy and active_task == "quest5":
		compleate_task()
	if active_task == "quest10" and !door_opened:
		door_opened = true
		QuestManager.allow_next_level.emit()
		exit_door_anim.play("default")
func _input(event):
	if dialog_area.character == "mr_tuto" and dialog_area.area_active == true and event.is_action_pressed("interact"):
		if active_task == "quest2":
			next_task()
		if task_done:
			next_task()
	if (event.is_action_pressed("right") or event.is_action_pressed("left")) and active_task == "quest1":
		compleate_task()
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and event.is_action_pressed("run") and active_task == "quest3":
		compleate_task()
	if event.is_action_pressed("jump") and active_task == "quest4":
		compleate_task()
	if event.is_action_pressed("ThrowKunai") and active_task == "quest6":
		compleate_task()
	if event.is_action_pressed("throwShuriken") and active_task == "quest7":
		compleate_task()
	if event.is_action_pressed("cast_fireball") and active_task == "quest8":
		compleate_task()
	if ChakraManager.current_chakra == ChakraManager.max_chakra and active_task == "quest9":
		compleate_task()
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
