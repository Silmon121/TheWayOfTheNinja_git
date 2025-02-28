extends Node

var mr_tuto_dialog_file = FileAccess.open("res://assets/data/dialogues/mr_tuto/mr_tuto_dialogue.json", FileAccess.READ) #Just loading the json file

var first_dialog_section = "start"
var last_dialog_section = "last"

var mr_tuto_character = "mr_tuto"

var dialog_in_process : bool = false

signal display_dialog(dialogue_key, character) #Used in dialogue_area to emit signal that contains specific dialogue_key
signal dialog_opened
signal dialog_ended
signal player_in_dialog_area
signal player_out_of_dialog_area

func get_dictionary_from_json(json_file) -> Dictionary:
	var json_string = json_file.get_as_text()
	var json_dictionary = JSON.parse_string(json_string)
	return json_dictionary
