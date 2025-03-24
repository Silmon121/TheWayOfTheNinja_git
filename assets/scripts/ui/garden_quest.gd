class_name GardenQuest extends Quest

@export var enemy_node: Node2D
@export var training_area: Area2D
func _ready():
	load_quests(quest_file)
func _process(delta):
	enemies_defeated()
func _input(event):
	if event.is_action_pressed("interact") and dialog_area.area_active:
		if active_task == "quest4":
			if !DialogManager.dialog_in_process:
				LevelManager.next_level("res://assets/scenes/levels/forest/forest_level.tscn")
		if active_task == "quest1":
			await get_tree().create_timer(0.1).timeout
			next_task()
		if task_done:
			next_task()
func _on_training_ground_quest_area_area_entered(area):
	if active_task == "quest2":
		DialogManager.start_dialog(training_area.dialog_file, "quest3", "mr_tuto")
		next_task()
func enemies_defeated():
	if enemy_node.get_children().size() == 4 and active_task == "quest3":
		complete_task()
