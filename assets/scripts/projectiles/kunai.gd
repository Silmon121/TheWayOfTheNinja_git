extends CharacterBody2D
class_name Kunai
var direction: float
var spawnPos: Vector2
var spawnRot: float
signal FireBallHit
@export var projectileSpeed = 500;
func _physics_process(delta):
	position.x += direction * projectileSpeed * delta
	move_and_slide()
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	$AnimationPlayer.play("KunaiRight")
func destroy():
	queue_free()


func _on_kunai_area_area_entered(area):
	if(area.name == "hitArea"):
		$KunaiHit.play()
		hide()
		if(!$KunaiHit.playing):
			destroy()
