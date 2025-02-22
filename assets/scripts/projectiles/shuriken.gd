extends CharacterBody2D
class_name Shuriken
var direction: float
var spawnPos: Vector2
var spawnRot: float
@export var projectileSpeed = 600;
func _physics_process(delta):
	position.x += direction * projectileSpeed * delta
	move_and_slide()
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	$AnimationPlayer.play("flyingShurikenRight")
func destroy():
	queue_free()
func _on_shuriken_area_area_entered(area):
	if area.is_in_group("enemy"):
		DamageNumbers.displayNumber(10,area.global_position)
		%ShurikenHit.play()
		hide()
		if(!%ShurikenHit.playing):
			destroy()
