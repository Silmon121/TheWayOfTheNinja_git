extends Path2D

@onready var anim_movement = $PathFollow2D/NinjaSpirit/NinjaSpiritAnimation
@onready var anim_path = %PathMovementAnimation
@onready var path = $PathFollow2D
@onready var previous_progress_ratio: float
@export var spirit: CharacterBody2D
@export var hurt_box: Area2D
@export var hit_box: Area2D

enum Type{
	TYPE1
}

@export_group("Path")
@export var type: Type

func _ready():
	if type == Type.TYPE1:
		anim_path.play("move_along_path")
func _process(delta):
	if spirit.health > 0:
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
		if spirit.dead:
			if path.progress_ratio > previous_progress_ratio or path.progress_ratio == 1:
				anim_movement.play("death_right")
			elif path.progress_ratio < previous_progress_ratio or path.progress_ratio == 0:
				anim_movement.play("death_left")
			hurt_box.monitorable = false
			hurt_box.monitoring = false
			hit_box.deal_damage = false
			anim_path.pause()
			await get_tree().create_timer(3).timeout
			queue_free()
func _on_ninja_spirit_animation_animation_finished(anim_name):
	if anim_name == "death_left":
		queue_free()
	elif anim_name == "death_right":
		queue_free()
