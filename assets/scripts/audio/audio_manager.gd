extends Node

@export_group("Sound effects")
@export_subgroup("Fireball")
@export var fireball_hit: AudioStreamPlayer2D
@export var fireball_cast: AudioStreamPlayer2D
@export_subgroup("Kunai")
@export var kunai_hit: AudioStreamPlayer2D
@export var kunai_throw: AudioStreamPlayer2D
@export_subgroup("Shuriken")
@export var shuriken_hit: AudioStreamPlayer2D
@export var shuriken_throw: AudioStreamPlayer2D
@export_subgroup("Movement")
@export var footsteps_walk: AudioStreamPlayer2D
@export var footsteps_run: AudioStreamPlayer2D
@export var wood_land: AudioStreamPlayer2D
@export_subgroup("Melee combat")
@export var katana_swing: AudioStreamPlayer2D

@export_group("Music")
@export var main_menu: AudioStreamPlayer
@export var dojo: AudioStreamPlayer
@export var garden: AudioStreamPlayer
@export var forest: AudioStreamPlayer

func footsteps_off():
	footsteps_walk.stop()
	footsteps_run.stop()
func turn_off_audio():
	for section in get_children():
		for audio in section.get_children():
			if audio is AudioStreamPlayer2D or audio is AudioStreamPlayer:
				audio.stop()
func play_space_audio(audio: AudioStreamPlayer2D, audio_pos):
	match audio:
		#FIREBALL
		fireball_hit:
			fireball_hit.position = audio_pos
			fireball_hit.play()
		fireball_cast:
			fireball_cast.position = audio_pos
			fireball_cast.play()
		#KUNAI
		kunai_hit:
			kunai_hit.position = audio_pos
			kunai_hit.play()
		kunai_throw:
			kunai_throw.position = audio_pos
			kunai_throw.play()
		#SHURIKEN
		shuriken_hit:
			shuriken_hit.position = audio_pos
			shuriken_hit.play()
		shuriken_throw:
			shuriken_throw.position = audio_pos
			shuriken_throw.play()
		#MOVEMENT
		wood_land:
			wood_land.position = audio_pos
			wood_land.play()
		footsteps_run:
			footsteps_run.position = audio_pos
			footsteps_run.play()
		footsteps_walk:
			footsteps_walk.position = audio_pos
			footsteps_walk.play()
		#MELEE COMBAT
		katana_swing:
			katana_swing.position = audio_pos
			katana_swing.play()
