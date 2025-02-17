extends TextureButton

func _ready():
	$CDFill.max_value = %FireballCDTimer.wait_time
	AbilityManager.fireball_casted.connect(start_timer)
func _process(_delta):
	if %FireballCDTimer.time_left != 0:
		$CDFill.value = %FireballCDTimer.time_left
		
func start_timer():
	if %FireballCDTimer.time_left == 0:
			%FireballCDTimer.start()
func _on_fireball_cd_timer_timeout():
	AbilityManager.fireball_ready = true
