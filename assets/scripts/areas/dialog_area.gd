class_name DialogArea extends Area2D

@export var npc : Node
@export_file("*.json") var dialog_file: String
@export var dialog_key = "" #Key to the json dictionary
@export var character = "" #This is used to determine which json dialog file should be loaded as a scene_text
@onready var interact_button_guide = npc.get_node("InteractButtonGuide")

var area_active = false

func _ready():
	PlayerManager.nearest_area_changed.connect(change_state)
func _input(event):
	if area_active and event.is_action_pressed("interact"):
		disable()
		DialogManager.start_dialog(dialog_file, dialog_key, character)
func change_state(area):
	if self == area:
		activate()
	else:
		disable()
#When player is only in one area and leaves it, he won't be able to change the state.
#This code ensures that the this area is disabled when player leaves.
func _on_area_exited(area):
	disable()
#Button methods
func disable():
	area_active = false
	interact_button_guide.visible = false
func activate():
	area_active = true
	interact_button_guide.visible = true
