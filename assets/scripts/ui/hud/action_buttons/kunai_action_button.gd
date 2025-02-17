extends TextureButton
func _ready():
	$CDFill.max_value = %KunaiCDTimer.wait_time
	AbilityManager.kunai_thrown.connect(start_timer)
func _process(_delta):
	if %KunaiCDTimer.time_left != 0:
		$CDFill.value = %KunaiCDTimer.time_left
func start_timer():
	if %KunaiCDTimer.time_left == 0:
		%KunaiCDTimer.start()
func _on_kunai_cd_timer_timeout():
	AbilityManager.kunai_ready = true
