extends TextureProgressBar

func _ready():
	#Sets counter to current_stamina/max_stamina without this it wouldn't have value until the signal for update is called.
	%StaminaCounter.text = str(floor(StaminaManager.current_stamina)) + "/"+ str(StaminaManager.max_stamina)
	max_value = StaminaManager.max_stamina
	#Connecting signal from StaminaManager to this node and assigning update_stamina method to it.
	StaminaManager.stamina_changed.connect(update_stamina)
#Updates hud stamina bar and it's label
func update_stamina():
	#StaminaBar update
	value = StaminaManager.current_stamina
	#StaminaCounter update
	%StaminaCounter.text = str(floor(StaminaManager.current_stamina)) + "/"+ str(StaminaManager.max_stamina)
	
