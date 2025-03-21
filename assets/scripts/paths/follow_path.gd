extends Path2D

@onready var anim_movement = $PathFollow2D/NinjaSpirit/NinjaSpiritAnimation
@onready var anim_path = %PathMovementAnimation
@onready var path = $PathFollow2D
@onready var previous_progress_ratio: float

enum Type{
	TYPE1
}

@export_group("Path")
@export var type: Type

func _ready():
	if type == Type.TYPE1:
		anim_path.play("move_along_path")
func _process(delta):
	if anim_movement != null:
		if path.progress_ratio == 1:
			anim_movement.play("idle_right")
		elif path.progress_ratio == 0:
			anim_movement.play("idle_left")
		elif  path.progress_ratio < previous_progress_ratio:
			anim_movement.play("walk_left")
		elif path.progress_ratio > previous_progress_ratio:
			anim_movement.play("walk_right")
		
		previous_progress_ratio = path.progress_ratio
	else:
		queue_free()
