extends TextureProgressBar

func _ready():
	#Sets counter to current_health/max_health without this, it wouldn't have value until the signal for update is called.
	%HPCounter.text = str(HealthManager.current_health) + "/"+ str(HealthManager.max_health) 
	max_value = HealthManager.max_health
	#Signal from HealthManager autoload script is connected to this node and will commence update_health method.
	HealthManager.health_changed.connect(update_health)
	await get_tree().create_timer(0.001).timeout
	update_health()
#Update progress bar and it's label
func update_health():
	#HealthBar update
	value = HealthManager.current_health
	#HPCounter update
	%HPCounter.text = str(HealthManager.current_health) + "/"+ str(HealthManager.max_health)
