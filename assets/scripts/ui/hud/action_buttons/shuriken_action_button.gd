extends TextureButton
func _ready():
	$CDFill.max_value = %ShurikenCDTimer.wait_time
	AbilityManager.shuriken_thrown.connect(start_timer)
func _process(_delta):
	if %ShurikenCDTimer.time_left != 0:
		$CDFill.value = %ShurikenCDTimer.time_left
func start_timer():
	if %ShurikenCDTimer.time_left == 0:
		%ShurikenCDTimer.start()
func _on_shuriken_cd_timer_timeout():
	AbilityManager.shuriken_ready = true
