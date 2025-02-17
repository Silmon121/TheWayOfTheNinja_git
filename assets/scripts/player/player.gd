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
@onready var moveDirection = 0; #MAIN SOURCE FOR OTHER DIRECTION VARIABLES
@onready var animation_direction = "Right"; #USED IN ANIMATIONS
@onready var lastMoveDirection = 1; #USED IN COMBAT
@onready var falling = false;
#COMBAT
@onready var attack = false
@onready var attackAnimationFinished = true;
@onready var chakraAnimationFinished = false;
@onready var shurikenReady = true;
@onready var kunaiReady = true;

func _ready():
	LevelManager.get_current_scene() #This will get the main node of the scene where the player currently is.
func _physics_process(delta):
	if !LevelManager.game_paused:
		direction_manager()
		move_and_slide()
		player_physics(delta)
#MOVEMENT - ALLOWS PLAYER TO MOVE, BUT DOESN'T CHANGE ANIMATIONS!
func player_physics(delta):
	combat()
	if Input.is_action_just_released("regenerate_chakra"):
		chakraAnimationFinished = false
	#Player is on the ground
	if is_on_floor():
		#Player has fallen to the ground
		if AbilityManager.falling:
			AbilityManager.falling = false
			$landOnFloor.play()
		if !Input.is_action_pressed("regenerate_chakra"):
			if (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
				if Input.is_action_pressed("run") and !StaminaManager.stamina_depleated:
					run(delta)
				else:
					walk(delta)
			else:
				idle()
			if Input.is_action_just_pressed("jump") and StaminaManager.current_stamina >= 10 and StaminaManager.stamina_depleated == false:
				jump()
		#Chakra regeneration
		else:
			if chakraAnimationFinished:
				animation.play("chakraRegenDuration" + animation_direction)
				ChakraManager.regenerate_chakra()
			else:
				animation.play("chakraRegen" + animation_direction)
	#Player is in the air
	else:
		fall(delta)
#MOVEMENT METHODS
func walk(delta):
	position.x += moveDirection * walk_speed * delta
	animation.play("walk"+ animation_direction)
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	if StaminaManager.stamina_recover_allowed:
		StaminaManager.recover_stamina(1) #Stamina starts recovering with multiplier set to 1x because the player is walking
	current_speed = walk_speed
	$footstepsRun.stop()
	if !$WalkFootsteps.playing:
		$WalkFootsteps.play()
func run(delta):
	position.x += moveDirection * sprint_speed * delta
	animation.play("run"+ animation_direction)
	StaminaManager.deplete_stamina(StaminaManager.stamina_depletion_rate)
	current_speed = sprint_speed
	$WalkFootsteps.stop()
	if(!$footstepsRun.playing):
		$footstepsRun.play()
func jump():
	velocity.y = jump_velocity
	animation.play("jump"+ animation_direction)
	AbilityManager.jumped.emit()
	StaminaManager.deplete_stamina(StaminaManager.stamina_jump_cost)
	$WalkFootsteps.stop()
	$footstepsRun.stop()
func fall(delta):
	velocity.y += gravity * delta
	position.x += current_speed * moveDirection *delta
	if velocity.y > 0:
		animation.play("fall"+ animation_direction)
	AbilityManager.falling = true
func idle():
	if stamina_recover_timer.time_left == 0 and StaminaManager.current_stamina != StaminaManager.max_stamina and !StaminaManager.stamina_recover_allowed:
		stamina_recover_timer.start()
	animation.play("idle"+ animation_direction)
	if StaminaManager.stamina_recover_allowed:
		StaminaManager.recover_stamina(2) #Stamina starts recovering with multiplier 2x because the player is standing still
	$WalkFootsteps.stop()
	$footstepsRun.stop()
#COMBAT METHODS

#ANIMATIONS - ALLOWS TO CHANGE PLAYER ANIMATIONS, BUT DOESN'T MAKE HIM MOVE!
func updateAnimation():
	#IS ON FLOOR ANIMATIONS
	if(animation != null):
		if attack and Input.is_action_just_pressed("attack") and attackAnimationFinished and is_on_floor():
			animation.play("katanaAttack1"+ animation_direction)
#COMBAT - ALLOWS PLAYER TO ATTACK
func combat():
	#MELEE_COMBAT
	if(Input.is_action_just_pressed("attack") and attack and attackAnimationFinished and is_on_floor()):
		$KatanaDamageBox/CollisionShape2D.disabled = false
		#attack = true
		attackAnimationFinished = false
		$KatanaSwing.play()
	else:
		$KatanaDamageBox/CollisionShape2D.disabled = true
	#Projectiles
	if Input.is_action_just_pressed("ThrowKunai") and AbilityManager.kunai_ready:
		throw_kunai()
	if Input.is_action_just_pressed("throwShuriken") and AbilityManager.shuriken_ready:
		throw_shuriken()
	if Input.is_action_just_pressed("cast_fireball") and ChakraManager.current_chakra > 9 and AbilityManager.fireball_ready and !Input.is_action_pressed("regenerate_chakra"):
		cast_fireball()
		
func throw_kunai():
	AbilityManager.kunai_ready = false
	AbilityManager.kunai_thrown.emit()
	#Creates new kunai instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_kunai(global_position, lastMoveDirection))
	$kunaiThrow.play()
func throw_shuriken():
	AbilityManager.shuriken_ready = false
	AbilityManager.shuriken_thrown.emit()
	#Creates new shuriken instance that is added to the scene using add_child to the current_scene
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_shuriken(global_position, lastMoveDirection))
	$ShurikenThrow.play()
func cast_fireball():
	AbilityManager.fireball_ready = false
	AbilityManager.fireball_casted.emit()
	#This part tells hud to decrease chakra by the fireball cost.
	ChakraManager.cast_spell(ChakraManager.fireball_cast_cost)
	#Adds fireball instance to the scene
	#Call deferred is jsut a safe way to add child into the scene, because it won't destroy the frames and godot won't be confused.
	LevelManager.main_node.add_child.call_deferred(SceneManager.create_fireball(global_position, lastMoveDirection))
	$FireBallCast.play()
#COLIDE REGISTRATION
#WHEN PLAYER COLIDES WITH AN ENEMY
func _on_hurt_box_area_entered(area):
	if area.name == "enemyArea":
		HealthManager.take_damage(10)
#CONTROL_FUNCTIONS
#DIRECTION_CONTROL
func direction_manager():
	moveDirection = 0
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		moveDirection = Input.get_axis("left", "right");
	if(moveDirection == 1 or moveDirection == -1):
		lastMoveDirection = moveDirection
	#DETERMINES THE DIRECTION OF ANIMATION
	if moveDirection == 1: 
		animation_direction = "Right"
	elif moveDirection == -1:
		animation_direction = "Left"
#STAMINA STARTS RECOVERING AFTER COOLDOWN
func _on_stamina_recover_timeout():
	StaminaManager.stamina_recover_allowed = true;
#ANIMATION FINISHED
#IF ATTACK ANIMATION FINISHED -> YOU CAN MOVE
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "katanaAttack1Right" or anim_name == "katanaAttack1Left"):
		attack = false
		attackAnimationFinished = true
	elif(anim_name == "chakraRegenRight" or anim_name == "chakraRegenLeft"):
		chakraAnimationFinished = true
#CONTROLS IN WHICH LEVEL PLAYER CURRENTLY IS

