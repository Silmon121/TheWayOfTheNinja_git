extends Area2D
@export var npc : Node
@export var dialog_key = "" #Key to the json dictionary
@export var character = "" #This is used to determine which json dialog file should be loaded as a scene_text
@onready var interact_button_guide = npc.get_node("InteractButtonGuide")
var area_active = false
func _ready():
	DialogManager.dialog_ended.connect(enable_area)
func _input(event):
	if area_active and event.is_action_pressed("interact"):
		area_active = false
		hide_button()
		DialogManager.dialog_opened.emit() #Only for the player to enter into idle animation when the dialog opens
		DialogManager.display_dialog.emit(dialog_key, character)
func _on_area_entered(area):
	area_active = true
	show_button()
func _on_area_exited(area):
	area_active = false
	hide_button()
func enable_area():
	area_active = true
	show_button()
func hide_button():
	interact_button_guide.visible = false
func show_button():
	interact_button_guide.visible = true
