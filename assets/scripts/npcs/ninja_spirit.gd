class_name NinjaSpirit extends Entity

func _ready():
	health = max_health
	health_bar.update()
