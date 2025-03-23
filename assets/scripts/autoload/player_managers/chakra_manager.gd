extends Node

var max_chakra: float = 50;
var current_chakra: float = max_chakra;
var chakra_recovery_rate: float = 0.5;
var fireball_cast_cost: float = 10;

signal chakra_changed

#Subtracts spell cost from current chakra
func cast_spell(spell_cost):
	if current_chakra - spell_cost >= 0:
		current_chakra -= spell_cost
		chakra_changed.emit()
#Regenerates chakra
func regenerate_chakra():
	current_chakra += chakra_recovery_rate
	if current_chakra > max_chakra:
		current_chakra = max_chakra
	chakra_changed.emit()
func fill_chakra():
	current_chakra = max_chakra
