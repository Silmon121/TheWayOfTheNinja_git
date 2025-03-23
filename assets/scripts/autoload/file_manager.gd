extends Node

func get_dictionary_from_json(json_file) -> Dictionary:
	var json_string = json_file.get_as_text()
	var json_dictionary = JSON.parse_string(json_string)
	return json_dictionary
