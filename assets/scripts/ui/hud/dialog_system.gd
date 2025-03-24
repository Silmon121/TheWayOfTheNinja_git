extends DialogManager

@onready var dialog_box = %DialogBoxCon
@onready var dialog_text = %DialogTextLabel

func _ready():
	dialog_box.visible = false #Hides the dialog box
	DialogManager.display_dialog.connect(on_display_dialog)
func _input(event):
	#Going through the dialog
	if (event.is_action_pressed("interact") or event.is_action_pressed("attack"))  and dialog_box.visible:
		next_line()
func on_display_dialog(dialog_file, text_key, character):
	if !DialogManager.dialog_in_process:
		DialogManager.dialog_in_process = true
		#for node in get_tree().get_nodes_in_group("animation"):
		#	node.process_mode = Node.PROCESS_MODE_ALWAYS
		load_dialog_set(dialog_file, text_key, character)
		#LevelManager.pause_game()
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
	await get_tree().create_timer(0.1).timeout
	DialogManager.dialog_in_process = false
	#LevelManager.resume_game()
	for node in get_tree().get_nodes_in_group("animation"): #This will make animations 
		node.process_mode = Node.PROCESS_MODE_INHERIT
	
	
