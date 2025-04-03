extends CharacterBody2D

@export_group("Entity config")
@export var max_health: int
@export var damage: int
@export var health_bar: EntityHealthBar
@export var animation: AnimationPlayer
var dead: bool = false
var health: int 

var custom_take_damage: Callable = Callable()

func take_damage(ammount: int):
	health -= ammount
	DamageNumbers.display_number(ammount, self.global_position, "enemy")
	if health <= 0:
		die()
	if custom_take_damage.is_valid():
		custom_take_damage.call()
	if health_bar != null:
		health_bar.update()
func die():
	health = 0
	dead = true
func destroy():
	queue_free()
