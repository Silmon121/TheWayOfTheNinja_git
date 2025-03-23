extends TextureProgressBar

@export var ui: UI
@export var counter: Label
@onready var player: Player = ui.player

func _ready():
	self.min_value = 0
	self.max_value = player.max_health
	update()
	PlayerManager.health_changed.connect(update)
func update():
	#HealthBar update
	value = player.health
	#HPCounter update
	counter.text = str(player.health) + "/"+ str(player.max_health)
