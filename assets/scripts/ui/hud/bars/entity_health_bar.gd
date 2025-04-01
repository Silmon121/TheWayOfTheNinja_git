class_name EntityHealthBar extends TextureProgressBar

@export_group("Config")
@export var entity: CharacterBody2D

@onready var display: Label = %NumberDisplayLabel

func _ready():
	self.min_value = 0
	self.max_value = entity.max_health
	hide()
func update():
	if entity.health < entity.max_health:
		show()
	elif entity.health <= 0:
		hide()
		print("Hiden")
	self.value = entity.health
	display.text = str(entity.health) + "/" + str(entity.max_health)
