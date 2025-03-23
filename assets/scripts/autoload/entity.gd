extends CharacterBody2D

@export_group("Entity config")
@export var max_health: int
@export var damage: int
@export var health_bar: EntityHealthBar
var health: int 

var custom_take_damage: Callable = Callable()

func take_damage(ammount: int):
	health -= ammount
	DamageNumbers.display_number(ammount, self.global_position)
	if health_bar != null:
		health_bar.update()
	if health <= 0:
		die()
	if custom_take_damage.is_valid():
		custom_take_damage.call()
func die():
	queue_free()
