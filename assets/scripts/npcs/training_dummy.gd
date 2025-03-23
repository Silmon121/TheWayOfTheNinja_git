class_name TrainingDummy extends Entity

func _ready():
	health = max_health
	custom_take_damage = func():
		DamageNumbers.player_attacked_enemy = true
