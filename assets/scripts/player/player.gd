extends CharacterBody2D
class_name Player
#Libraries
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #LIBRARY FOR GRAVITY
#nodes
@onready var animation = %AnimationPlayer #References animation file
@onready var stamina_recover_timer = %StaminaRecover
#MOVEMENT
#SPEED
@export var walk_speed : int = 100 #WALK SPEED
@export var sprint_speed: int = 225 #RUN SPEED
@export var jump_velocity: int  = -400 #jUMP SPEED

@onready var current_speed: int = walk_speed #HOLDS CURRENT PLAYER SPEED WHEN PLAYER JUMPS
#DIRECTION
@onready var falling = false;
#COMBAT
@onready var attack_anim_finished = true;
@onready var chakra_anim_finished = false;

func _ready():
	$KatanaDamageBox/CollisionShape2D.disabled = true
	LevelManager.get_current_scene() #This will get the main node of the scene where the player currently is.
func _physics_process(delta):
	if !LevelManager.game_paused:
		move_and_slide()
		player_physics(delta)
func _input(event):
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
	DirectionManager.get_direction()
	#This will disable katana attack collision box when the player will attack
	if !$KatanaDamageBox/CollisionShape2D.disabled:
		$KatanaDamageBox/CollisionShape2D.disabled = true
	#Player is on the ground
	if is_on_floor():
		#Player has fallen to the ground 
		#This will play landing sound
		if AbilityManager.falling:
			AbilityManager.falling = false
			$landOnFloor.play()
		if Input.is_action_just_pressed("attack") and !Input.is_action_pressed("regenerate_chakra") and attack_anim_finished:
			katana_attack()
		if attack_anim_finished:
			if Input.is_action_pressed("regenerate_chakra"):
				regenerate_chakra()
			else:
				if (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
					if Input.is_action_pressed("run") and !StaminaManager.stamina_depleated:
						run(delta)
					else:
						walk(delta)
				else:
					idle()
				if Input.is_action_just_pressed("jump") and StaminaManager.current_stamina >= 10 and StaminaManager.stamina_depleated == false:
					jump()
			
	#Player is in the air
	else:
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
	current_speed = walk_speed
	$footstepsRun.stop()
	if !$WalkFootsteps.playing:
		$WalkFootsteps.play()
func run(delta):
	position.x += DirectionManager.move_direction * sprint_speed * delta
	animation.play("run"+ DirectionManager.anim_direction)
	StaminaManager.deplete_stamina(StaminaManager.stamina_depletion_rate)
	current_speed = sprint_speed
	$WalkFootsteps.stop()
	if(!$footstepsRun.playing):
		$footstepsRun.play()
func jump():
	velocity.y = jump_velocity
	animation.play("jump"+ DirectionManager.anim_direction)
	AbilityManager.jumped.emit()
	StaminaManager.deplete_stamina(StaminaManager.stamina_jump_cost)
	$WalkFootsteps.stop()
	$footstepsRun.stop()
func fall(delta):
	velocity.y += gravity * delta
	position.x += current_speed * DirectionManager.move_direction * delta
	if velocity.y > 0:
		animation.play("fall"+ DirectionManager.anim_direction)
	AbilityManager.falling = true
func idle():
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	animation.play("idle"+ DirectionManager.anim_direction)
	if StaminaManager.stamina_recover_allowed:
		StaminaManager.recover_stamina(2) #Stamina starts recovering with multiplier 2x because the player is standing still
	$WalkFootsteps.stop()
	$footstepsRun.stop()
#COMBAT METHODS
#MELEE COMBAT
func katana_attack():
	$KatanaDamageBox/CollisionShape2D.disabled = false
	attack_anim_finished = false
	animation.play("katanaAttack1"+ DirectionManager.anim_direction)
	$KatanaSwing.play()
#PROJECTILES
func throw_kunai():
	AbilityManager.kunai_ready = false
	AbilityManager.kunai_thrown.emit()
	#Creates new kunai instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_kunai(global_position))
	$kunaiThrow.play()
func throw_shuriken():
	AbilityManager.shuriken_ready = false
	AbilityManager.shuriken_thrown.emit()
	#Creates new shuriken instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_shuriken(global_position))
	$ShurikenThrow.play()
func cast_fireball():
	AbilityManager.fireball_ready = false
	AbilityManager.fireball_casted.emit()
	#This part tells hud to decrease chakra by the fireball cost.
	ChakraManager.cast_spell(ChakraManager.fireball_cast_cost)
	#Adds fireball instance to the scene
	#Call deferred is jsut a safe way to add child into the scene, because it won't destroy the frames and godot won't be confused.
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_fireball(global_position))
	$FireBallCast.play()
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
		
#COLIDE REGISTRATION
#WHEN PLAYER COLIDES WITH AN ENEMY
func _on_hurt_box_area_entered(area):
	if area.name == "enemyArea":
		HealthManager.take_damage(10)
#TIMERS
#STAMINA STARTS RECOVERING AFTER COOLDOWN
func _on_stamina_recover_timeout():
	StaminaManager.stamina_recover_allowed = true;
#ANIMATION FINISHED
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "katanaAttack1Right" or anim_name == "katanaAttack1Left"):
		attack_anim_finished = true
	elif(anim_name == "chakraRegenRight" or anim_name == "chakraRegenLeft"):
		chakra_anim_finished = true
#When katana will hit an enemy
func _on_katana_damage_box_area_entered(area):
	if area.is_in_group("enemy"):
		DamageNumbers.displayNumber(25,area.global_position)
