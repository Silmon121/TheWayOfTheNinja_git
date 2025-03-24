class_name TutorialQuest extends Quest

@export_group("Animation")
@export var exit_door_anim: AnimatedSprite2D

func _ready():
	load_quests(quest_file)
func _process(delta):
	#Player has to go near mr. tuto
	#When he does it will trigger a dialog
	if dialog_area.area_active == true:
		if active_task == "quest1":
			next_task()
			DialogManager.start_dialog(dialog_area.dialog_file,"quest2", "mr_tuto")
			#Prevents activating area twice
			dialog_area.disable()
	if DamageNumbers.player_attacked_enemy and active_task == "quest5":
		complete_task()
	if active_task == "quest10" and !door_opened:
		door_opened = true
		Quest.allow_next_level.emit() 
		exit_door_anim.play("default")
func _input(event):
	#When the player has completed the current quest, he will be able to start new one.
	#By talking to the mr. tuto
	if dialog_area.area_active == true and event.is_action_pressed("interact"):
		if task_done or active_task == "quest2":
			next_task()
	#BASICS
	if !DialogManager.dialog_in_process:
		if (event.is_action_pressed("right") or event.is_action_pressed("left")) and active_task == "quest1":
			complete_task()
		if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and Input.is_action_pressed("run") and active_task == "quest3":
			complete_task()
		if event.is_action_pressed("jump") and active_task == "quest4":
			complete_task()
		if event.is_action_pressed("ThrowKunai") and active_task == "quest6":
			complete_task()
		if event.is_action_pressed("throwShuriken") and active_task == "quest7":
			complete_task()
		if event.is_action_pressed("cast_fireball") and active_task == "quest8":
			complete_task()
		if ChakraManager.current_chakra == ChakraManager.max_chakra and active_task == "quest9":
			complete_task()
			

