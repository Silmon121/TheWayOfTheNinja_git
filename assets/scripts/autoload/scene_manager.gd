extends Node

var fireball = load("res://assets/scenes/projectiles/fireball.tscn")
var shuriken = load("res://assets/scenes/projectiles/shuriken.tscn")
var kunai = load("res://assets/scenes/projectiles/kunai.tscn")

#Func for creating fireball instance
func create_fireball(global_position) -> Node:
	var fireball_instance = fireball.instantiate()
	fireball_instance.direction = DirectionManager.face_direction
	if (DirectionManager.face_direction == -1):
		fireball_instance.global_position = global_position - Vector2(30,0)
	else:
		fireball_instance.global_position = global_position+ Vector2(30,0)
	return fireball_instance
#Func for creating kunai instance
func create_kunai(global_position) -> Node:
	var kunai_instance = kunai.instantiate()
	kunai_instance.direction = DirectionManager.face_direction
	if (DirectionManager.face_direction == -1):
		kunai_instance.global_position = global_position - Vector2(30,0)
	else:
		kunai_instance.global_position = global_position+ Vector2(30,0)
	return kunai_instance
#Func for creating shuriken instance
func create_shuriken(global_position) -> Node:
	var shuriken_instance = shuriken.instantiate()
	shuriken_instance.direction = DirectionManager.face_direction
	if (DirectionManager.face_direction == -1):
		shuriken_instance.global_position = global_position - Vector2(30,0)
	else:
		shuriken_instance.global_position = global_position+ Vector2(30,0)
	return shuriken_instance
