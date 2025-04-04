extends CharacterBody2D

var direction: float
var spawn_pos: Vector2
var spawn_rot: float

@export_group("Config")
@export var projectile_name: String
@export var projectile_speed: int
@export var damage: int
var custom_hit_audio: Callable = Callable()

@export_group("Animation")
@export var anim_player: AnimationPlayer

#Method for moving the projectile
func move(delta, projectile:Node):
	projectile.position.x += direction * projectile_speed * delta
	move_and_slide()
func play_anim():
	if anim_player != null:
		anim_player.play(projectile_name + "_" + DirectionManager.anim_direction.to_lower())
#Method for the time when the projectile hits target
func hit(projectile:Node):
	custom_hit_audio.call()
	destroy()
#Method for removing the projectile from the scene tree
func destroy():
	queue_free()
