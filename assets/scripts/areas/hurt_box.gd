extends Area2D

@export var entity: CharacterBody2D

func _on_area_entered(area):
	if area.is_in_group("hitbox") and area.deal_damage:
		entity.take_damage(area.damage)
	if area.is_in_group("katana") and LevelManager.main_node.name == "TutorialLevelDojo":
		DamageNumbers.player_attacked_enemy = true
func turn_off():
	monitoring = false
	monitorable = false
