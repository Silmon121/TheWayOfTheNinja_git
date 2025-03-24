class_name Player extends PlayerManager


@onready var stamina_recover_timer = %StaminaRecover
@onready var katana_hitbox = %KatanaCollisionBox

#Current speed
@onready var current_speed: int = walk_speed #HOLDS CURRENT PLAYER SPEED WHEN PLAYER JUMPS
@onready var audio = AudioManager

@onready var falling: bool = false;
#COMBAT
@onready var attack_anim_finished: bool = true;
@onready var chakra_anim_finished: bool = false;

@onready var area_list: Array

func _ready():
	health = max_health 
	katana_hitbox.disabled = true
	LevelManager.get_current_scene() #This will get the main node of the scene where the player currently is.

func _physics_process(delta):
	move_and_slide()
	player_physics(delta)
	if !area_list.is_empty() and is_on_floor() and !DialogManager.dialog_in_process:
		PlayerManager.nearest_area_changed.emit(get_nearest_area())
func _input(event):
	if !DialogManager.dialog_in_process:
		if event.is_action_released("regenerate_chakra"):
			chakra_anim_finished = false
		#COMBAT
		#PROJECTILES
		if event.is_action_pressed("ThrowKunai") and AbilityManager.kunai_ready:
			throw_kunai()
		if event.is_action_pressed("throwShuriken") and AbilityManager.shuriken_ready:
			throw_shuriken()
		if event.is_action_pressed("cast_fireball") and ChakraManager.current_chakra > 9 and AbilityManager.fireball_ready and !Input.is_action_pressed("regenerate_chakra"):
			cast_fireball()
#MAIN PLAYER PHYSICS FUNCTION
func player_physics(delta):
	#Get the direciton
	if !DialogManager.dialog_in_process:
		DirectionManager.get_direction()
	#This will disable katana attack collision box when the player will attack
	if !katana_hitbox.disabled:
		katana_hitbox.disabled = true
	#Player is on the ground
	if is_on_floor():
		#Player has fallen to the ground 
		#This will play landing sound
		if AbilityManager.falling:
			AbilityManager.falling = false
			audio.play_space_audio(audio.wood_land, global_position)
		if Input.is_action_just_pressed("attack") and !Input.is_action_pressed("regenerate_chakra") and attack_anim_finished and !DialogManager.dialog_in_process:
			katana_attack()
		if attack_anim_finished:
			if Input.is_action_pressed("regenerate_chakra") and !DialogManager.dialog_in_process:
				regenerate_chakra()
			else:
				if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and !DialogManager.dialog_in_process:
					if Input.is_action_pressed("run") and !StaminaManager.stamina_depleated:
						run(delta)
					else:
						walk(delta)
				else:
					idle()
				if Input.is_action_just_pressed("jump") and !DialogManager.dialog_in_process:
					if Input.is_action_pressed("down"):
						set_collision_mask_value(9,false)
					else:
						if StaminaManager.current_stamina >= 10 and StaminaManager.stamina_depleated == false:
							jump()
	#Player is in the air
	else:
		#Player is able to go through the platforms 
		#By turning off his collision with the platform layer
		if Input.is_action_pressed("down"):
			set_collision_mask_value(9,false)
		else:
			set_collision_mask_value(9,true)
		fall(delta)
#CUSTOM MADE METHODS
#MOVEMENT METHODS
func walk(delta):
	position.x += DirectionManager.move_direction * walk_speed * delta
	animation.play("walk"+ DirectionManager.anim_direction)
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	if StaminaManager.stamina_recover_allowed:
		StaminaManager.recover_stamina(1) #Stamina starts recovering with multiplier set to 1x because the player is walking
	current_speed = walk_speed #For jumping speed 
	#AUDIO
	audio.footsteps_run.stop()
	if !audio.footsteps_walk.playing:
		audio.play_space_audio(audio.footsteps_walk, global_position)
func run(delta):
	position.x += DirectionManager.move_direction * sprint_speed * delta
	animation.play("run"+ DirectionManager.anim_direction)
	StaminaManager.deplete_stamina(StaminaManager.stamina_depletion_rate)
	current_speed = sprint_speed
	#AUDIO
	audio.footsteps_walk.stop()
	if(!audio.footsteps_run.playing):
		audio.play_space_audio(audio.footsteps_run, global_position)
func jump():
	velocity.y = jump_velocity
	animation.play("jump"+ DirectionManager.anim_direction)
	AbilityManager.jumped.emit()
	StaminaManager.deplete_stamina(StaminaManager.stamina_jump_cost)
	audio.footsteps_off()
func fall(delta):
	velocity.y += gravity * delta
	position.x += current_speed * DirectionManager.move_direction * delta
	if velocity.y > 0:
		animation.play("fall"+ DirectionManager.anim_direction)
	AbilityManager.falling = true
func idle():
	attack_anim_finished = true
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	animation.play("idle"+ DirectionManager.anim_direction)
	if StaminaManager.stamina_recover_allowed:
		StaminaManager.recover_stamina(2) #Stamina starts recovering with multiplier 2x because the player is standing still
	audio.footsteps_off()
#COMBAT METHODS
#MELEE COMBAT
func katana_attack():
	katana_hitbox.disabled = false
	attack_anim_finished = false
	animation.play("katana_attack_"+ DirectionManager.anim_direction)
	audio.play_space_audio(audio.katana_swing, global_position)
#PROJECTILES
func throw_kunai():
	#HUD registration
	AbilityManager.kunai_ready = false
	AbilityManager.kunai_thrown.emit()
	#Creates new kunai instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_kunai(global_position))
	audio.play_space_audio(audio.kunai_throw, global_position)
func throw_shuriken():
	AbilityManager.shuriken_ready = false
	AbilityManager.shuriken_thrown.emit()
	#Creates new shuriken instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_shuriken(global_position))
	audio.play_space_audio(audio.shuriken_throw, global_position)
func cast_fireball():
	AbilityManager.fireball_ready = false
	AbilityManager.fireball_casted.emit()
	#This part tells hud to decrease chakra by the fireball cost.
	ChakraManager.cast_spell(ChakraManager.fireball_cast_cost)
	#Adds fireball instance to the scene
	#Call deferred is jsut a safe way to add child into the scene, because it won't destroy the frames and godot won't be confused.
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_fireball(global_position))
	audio.play_space_audio(audio.fireball_cast, global_position)
func regenerate_chakra():
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	if StaminaManager.stamina_recover_allowed:
			StaminaManager.recover_stamina(2)
	if chakra_anim_finished:
		animation.play("chakraRegenDuration" + DirectionManager.anim_direction)
		ChakraManager.regenerate_chakra()
	else:
		animation.play("chakraRegen" + DirectionManager.anim_direction)
#TIMERS
#STAMINA STARTS RECOVERING AFTER COOLDOWN
func _on_stamina_recover_timeout():
	StaminaManager.stamina_recover_allowed = true;
#ANIMATION FINISHED
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "katana_attack_Right" or anim_name == "katana_attack_Left"):
		attack_anim_finished = true
	elif(anim_name == "chakraRegenRight" or anim_name == "chakraRegenLeft"):
		chakra_anim_finished = true

#NEAREST AREA IDENTIFICATION
#This will add any area that player can collide with into the area list
func _on_player_interaction_area_area_entered(area):
	if area not in area_list:
		area_list.append(area)
#This will remove any area that player is currently in
func _on_player_interaction_area_area_exited(area):
	if area in area_list:
		area_list.erase(area)
#This function will determine the nearest area
func get_nearest_area() -> Node:
	#This declaration will return always the first area because there aren't any other areas
	var closest_area: float = get_distance_to_area(area_list[0])
	var nearest_area: Node = area_list[0]
	#This logic will happen when player is in multiple areas
	if area_list.size() > 1:
		for area in area_list: #For all areas the player currently is in
			var area_distance = get_distance_to_area(area) #Get distance to the n-th area
			if area_distance <= closest_area: #if new n-th area is closer to the player then
				closest_area = area_distance #New closest distance
				nearest_area = area #New closes area Node
	return nearest_area #Funciton returns closest area Node 
func get_distance_to_area(area) -> float:
	return self.global_position.distance_to(area.global_position) #Comparing the area's global_position to player's



