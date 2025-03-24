class_name ForestQuest extends Quest

@export var enemy_node: Node2D
@export_file("*.json") var dialog_file: String 
var quest_done: bool = false
func _ready():
	load_quests(quest_file)
	quest_progress()
func _process(delta):
	if !quest_done:
		enemies_defeated()
func enemies_defeated():
	if enemy_node.get_children().size() == 0:
		quest_done = true
		complete_task()
		DialogManager.start_dialog(dialog_file, "quest1", "author")
		await get_tree().create_timer(3).timeout
		LevelManager.next_level("res://assets/scenes/ui/menus/credits.tscn")
