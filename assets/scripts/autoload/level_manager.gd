extends Node2D

var main_node: Node
@export_file var current_level_path: String

signal level_changed

func get_current_scene() -> Node:
	#This will get the scene where player currently is
	#In the root there are autoloads first as it's children, but main node e.g Dojo is always last so I am using last index of roots children to get the e.g Dojo node.
	#I can use current_scene for creating new objects.
	main_node = get_tree().get_root().get_child(-1)
	return main_node
func exit_game():
	get_tree().quit()
func pause_game():
	get_tree().paused = true
func resume_game():
	get_tree().paused = false
func next_level(new_level):
	get_tree().change_scene_to_file(new_level)
	level_changed.emit() #This will be used later to set health back to 100 when player reaches new level
func reset_stats():
	LevelManager.current_level_path = current_level_path
	AbilityManager.restore_abilities()
	AudioManager.turn_off_audio()
	DialogManager.dialog_in_process = false
	ChakraManager.current_chakra = ChakraManager.max_chakra
	StaminaManager.current_stamina = StaminaManager.max_stamina
func retry():
	get_tree().change_scene_to_file(current_level_path)
