class_name TutorialQuest extends Quest

@export_group("Animation")
@export var exit_door_anim: AnimatedSprite2D

func _ready():
	load_quests()
func _process(delta):
	if dialog_area.character == "mr_tuto" and dialog_area.area_active == true:
		if active_task == "quest1":
			next_task()
			start_quest_dialog("quest2", "mr_tuto")
			#Prevents activating area twice
			dialog_area.area_active = false
			dialog_area.hide_button()
	if DamageNumbers.player_attacked_enemy and active_task == "quest5":
		compleate_task()
	if active_task == "quest10" and !door_opened:
		door_opened = true
		Quest.allow_next_level.emit() 
		exit_door_anim.play("default")
func _input(event):
	if dialog_area.character == "mr_tuto" and dialog_area.area_active == true and event.is_action_pressed("interact"):
		if active_task == "quest2":
			next_task()
		if task_done:
			next_task()
	if (event.is_action_pressed("right") or event.is_action_pressed("left")) and active_task == "quest1":
		compleate_task()
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and Input.is_action_pressed("run") and active_task == "quest3":
		compleate_task()
	if event.is_action_pressed("jump") and active_task == "quest4":
		compleate_task()
	if event.is_action_pressed("ThrowKunai") and active_task == "quest6":
		compleate_task()
	if event.is_action_pressed("throwShuriken") and active_task == "quest7":
		compleate_task()
	if event.is_action_pressed("cast_fireball") and active_task == "quest8":
		compleate_task()
	if ChakraManager.current_chakra == ChakraManager.max_chakra and active_task == "quest9":
		compleate_task()
		

