extends Node

@export_group("Sound effects")
@export var fireball_hit: AudioStreamPlayer2D
@export var kunai_hit: AudioStreamPlayer2D
@export var shuriken_hit: AudioStreamPlayer2D

@export_group("Music")
@export var main_menu: AudioStreamPlayer
@export var dojo: AudioStreamPlayer
@export var garden: AudioStreamPlayer
@export var forest: AudioStreamPlayer

func turn_off_audio():
	for section in get_children():
		for audio in section.get_children():
			if audio is AudioStreamPlayer2D or audio is AudioStreamPlayer:
				audio.stop()
func play_space_audio(audio: AudioStreamPlayer2D, audio_pos):
	print("sdfs" + str(audio_pos))
	match audio:
		fireball_hit:
			fireball_hit.position = audio_pos
			fireball_hit.play()
			print("Fireball: "+str(fireball_hit.position))
		kunai_hit:
			kunai_hit.position = audio_pos
			kunai_hit.play()
			print("Kunai: "+str(kunai_hit.position))
		shuriken_hit:
			shuriken_hit.position = audio_pos
			shuriken_hit.play()
			print("Shuriken: "+str(shuriken_hit.position))

func _on_fireball_hit_audio_finished():
	fireball_hit.position = Vector2(0,0)

func _on_kunai_hit_audio_finished():
	kunai_hit.position = Vector2(0,0)

func _on_shuriken_hit_audio_finished():
	shuriken_hit.position = Vector2(0,0)
