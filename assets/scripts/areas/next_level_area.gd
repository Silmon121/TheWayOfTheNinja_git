extends Area2D

@export var next_level: String
@export var interact_button_guide: Node

var area_active = false
func _ready():
	config()
	PlayerManager.nearest_area_changed.connect(change_state)
	Quest.allow_next_level.connect(open_exit)

func _input(event):
	if area_active and event.is_action_pressed("interact") and !DialogManager.dialog_in_process:
		get_tree().change_scene_to_file(next_level)
func _on_area_exited(area):
	area_active = false
	interact_button_guide.visible = false
func change_state(area):
	if self == area:
		area_active = true
		interact_button_guide.visible = true
	else:
		area_active = false
		interact_button_guide.visible = false
func open_exit():
	self.monitorable = true
	self.monitoring = true
func _on_area_entered(area):
	area_active = true
	interact_button_guide.visible = true
func config():
	self.monitorable = false
	self.monitoring = false
	interact_button_guide.visible = false
