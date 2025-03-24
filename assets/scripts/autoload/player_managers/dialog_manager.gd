extends Node

var dialog_in_process : bool = false
var scene_text = {}
var selected_text = []

signal display_dialog(dialog_file, dialogue_key, character) #Used in dialogue_area to emit signal that contains specific dialogue_key
signal dialog_opened

func load_dialog_set(dialog_file, text_key, character):
	var dialog_json = FileAccess.open(dialog_file, FileAccess.READ)
	if scene_text.is_empty(): #This is loading the specific dialog file for the character
		scene_text = FileManager.get_dictionary_from_json(dialog_json)
	selected_text = scene_text[text_key].duplicate()
func start_dialog(dialog_file, dialog_key, character):
	dialog_opened.emit() #Only for the player to enter into idle animation when the dialog opens
	display_dialog.emit(dialog_file, dialog_key, character)
