class_name Shuriken extends Projectile

#Plays animation when new instance is created
func _ready():
	play_anim()
#Moves the projectile
func _physics_process(delta):
	move(delta, self)
#Controls when the projectile collides
func _on_hit_box_area_entered(area):
	if area.is_in_group("hurtbox"):
		hit(self)
