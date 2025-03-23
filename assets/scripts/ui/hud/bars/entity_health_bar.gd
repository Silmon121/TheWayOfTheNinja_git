class_name EntityHealthBar extends TextureProgressBar

@export_group("Config")
@export var entity: CharacterBody2D

@onready var display: Label = %NumberDisplayLabel

func _ready():
	self.min_value = 0
	self.max_value = entity.max_health
	
func update():
	self.value = entity.health
	display.text = str(entity.health) + "/" + str(entity.max_health)
