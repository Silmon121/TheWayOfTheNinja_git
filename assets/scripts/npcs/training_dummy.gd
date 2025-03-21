class_name TrainingDummy extends Entity

func _ready():
	custom_take_damage = func():
		DamageNumbers.player_attacked_enemy = true
