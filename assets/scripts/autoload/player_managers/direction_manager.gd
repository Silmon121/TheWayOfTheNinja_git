extends Node
var move_direction = 0
var face_direction = 1
var anim_direction = "Right"

func get_direction():
	move_direction = 0
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		move_direction = Input.get_axis("left", "right");
	if(move_direction == 1 or move_direction == -1):
		face_direction = move_direction
	#DETERMINES THE DIRECTION OF ANIMATION
	if move_direction == 1: 
		anim_direction = "Right"
	elif move_direction == -1:
		anim_direction = "Left"
