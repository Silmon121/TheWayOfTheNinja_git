extends Path2D

@onready var anim_movement = $PathFollow2D/EnemyNinja/EnemyNinjaAnimation
@onready var anim_path = $EnemyNinjaPath
@onready var path = $PathFollow2D
@onready var previous_progress_ratio: float
@export var enemy_ninja: CharacterBody2D
@export var hurt_box: Area2D
@export var hit_box: Area2D

enum Type{
	TYPE1,
	TYPE2
}

@export_group("Path")
@export var type: Type

func _ready():
	if type == Type.TYPE1:
		anim_path.play("type1")
	elif type == Type.TYPE2:
		anim_path.play("type2")
func _process(delta):
	if enemy_ninja.health > 0:
		if anim_movement != null:
			if type == Type.TYPE1:
				if path.progress_ratio == 1:
					anim_movement.play("idle_right")
				elif path.progress_ratio == 0:
					anim_movement.play("idle_left")
				elif  path.progress_ratio < previous_progress_ratio:
					anim_movement.play("walk_left")
				elif path.progress_ratio > previous_progress_ratio:
					anim_movement.play("walk_right")
			elif type == Type.TYPE2:
				if path.progress_ratio == 1:
					anim_movement.play("idle_left")
				elif path.progress_ratio == 0:
					anim_movement.play("idle_right")
				elif  path.progress_ratio < previous_progress_ratio:
					anim_movement.play("walk_right")
				elif path.progress_ratio > previous_progress_ratio:
					anim_movement.play("walk_left")
			previous_progress_ratio = path.progress_ratio
	else: 
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		hit_box.deal_damage = false
		anim_path.pause()
		queue_free()
