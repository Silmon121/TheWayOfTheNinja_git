extends Node

var max_health: int = 100;
var current_health: int = max_health;

signal health_changed

#Player takes damage
func take_damage(amount: int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	health_changed.emit()
#Heals the player
func heal(amount: int):
	current_health += amount
	if current_health >= max_health:
		current_health = max_health
	health_changed.emit()
func fill_health():
	current_health = max_health
