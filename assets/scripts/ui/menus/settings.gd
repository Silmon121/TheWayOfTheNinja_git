extends Control
#Getting type of window mode already being used
@export var master_volume: HSlider
@export var music_volume: HSlider
@export var sfx_volume: HSlider
func _ready():
	AudioManager.turn_off_audio()
	AudioManager.main_menu.play()
	if(DisplayServer.window_get_mode() == 3):
		%OptionButton.selected = 0
	elif(DisplayServer.window_get_mode() == 0):
		%OptionButton.selected = 1
	else:
		%OptionButton.selected = 1
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
#Selecting resolution
func _on_option_button_item_selected(index):
	if(index == 0):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	elif(index == 1):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
#Back button pressed
func _on_button_pressed():
	AudioServer.set_bus_volume_db(0,linear_to_db(master_volume.value))
	AudioServer.set_bus_volume_db(1,linear_to_db(music_volume.value))
	AudioServer.set_bus_volume_db(2,linear_to_db(sfx_volume.value))
	get_tree().change_scene_to_file("res://assets/scenes/ui/menus/main_menu.tscn")


func _on_master_volume_slider_mouse_exited():
	release_focus()


func _on_music_volume_slider_mouse_exited():
	release_focus()


func _on_sfx_volume_slider_mouse_exited():
	release_focus()
