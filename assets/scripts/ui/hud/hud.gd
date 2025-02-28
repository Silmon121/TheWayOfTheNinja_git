extends Control

var scene_text = {}
var selected_text = []

@onready var dialog_box = %DialogBoxCon
@onready var dialog_text = %DialogTextLabel

func _ready():
	dialog_box.visible = false #Hides the dialog box
	DialogManager.display_dialog.connect(on_display_dialog)
func _input(event):
	if (event.is_action_pressed("attack") or event.is_action_pressed("interact")) and dialog_box.visible:
		next_line()
func on_display_dialog(text_key, character):
	if !DialogManager.dialog_in_process:
		DialogManager.dialog_in_process = true
		for node in get_tree().get_nodes_in_group("animation"):
			node.process_mode = Node.PROCESS_MODE_ALWAYS
		if scene_text.is_empty(): #This is loading the specific dialog file for the character
			if character == "mr_tuto":
				scene_text = DialogManager.get_dictionary_from_json(DialogManager.mr_tuto_dialog_file)
			selected_text = scene_text[text_key].duplicate() #Makes duplicate of the scene_text dictionary to avoid accidental erasure of data.
		LevelManager.pause_game()
		dialog_box.visible = true
		show_text()
	else:
		next_line()
func show_text():
	dialog_text.text = selected_text.pop_front() #Reads the first line of json file and erases it. That's why I duplicate the json file before pop_front()
func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()
func finish():
	dialog_text.text = "" #clear the label
	dialog_box.visible = false #Hides the dialog box
	scene_text.clear() #Clears the dictionary for more use
	DialogManager.dialog_in_process = false
	LevelManager.resume_game()
	for node in get_tree().get_nodes_in_group("animation"): #This will make animations 
		node.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().create_timer(0.1).timeout #Waits some time before enabling the area, to prevent activating the dialog again.
	DialogManager.dialog_ended.emit() #This is for the dialog area to enable again.
	
