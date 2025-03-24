extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #LIBRARY FOR GRAVITY

@export_group("Movement")
@export var walk_speed : int#WALK SPEED
@export var sprint_speed: int #RUN SPEED
@export var jump_velocity: int #jUMP SPEED


@export_group("Health")
@export var max_health: int
var health: int

@export_group("Animation")
@export var animation: AnimationPlayer
@export_group("Audio")


signal health_changed()
signal nearest_area_changed(nearest_area)

func take_damage(ammount: int):
	health -= ammount
	if health <= 0:
		health = 0
		queue_free()
	DamageNumbers.display_number(ammount, global_position, "player")
	PlayerManager.health_changed.emit()
