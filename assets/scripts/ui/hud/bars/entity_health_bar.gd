extends TextureProgressBar

@export_group("Config")
@export var entity: CharacterBody2D

@onready var display: Label = %NumberDisplayLabel

func _ready():
	self.min_value = 0
	self.value = entity.max_health
	self.max_value = entity.max_health
	display.text = str(entity.max_health) + "/" + str(entity.max_health)
