extends Node

var max_stamina: float = 150;
var current_stamina: float = max_stamina;
var stamina_recovery_rate: float = 0.5;
var stamina_depletion_rate: float = 0.5;
var stamina_jump_cost: int = 10;

var stamina_depleated: bool = false;
var stamina_recover_allowed: bool = false

signal stamina_changed

func deplete_stamina(ammount: float):
	stamina_recover_allowed = false
	current_stamina -= ammount
	if current_stamina <= 0:
		current_stamina = 0
		stamina_depleated = true
	stamina_changed.emit()
func recover_stamina(multiplier: float):
	current_stamina += stamina_recovery_rate * multiplier
	if current_stamina >= max_stamina:
		current_stamina = max_stamina
		stamina_depleated = false
		stamina_recover_allowed = false
	stamina_changed.emit()
func fill_stamina():
	current_stamina = max_stamina
