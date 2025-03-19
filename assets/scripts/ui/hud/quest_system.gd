extends MarginContainer

@onready var name_label: Label = %QuestNameLabel
@onready var description_label: Label =  %QuestDescLabel

func _ready():
	QuestManager.update_quest.connect(update)
func update(quest_name,quest_description):
	name_label.text = quest_name
	description_label.text = quest_description
	
