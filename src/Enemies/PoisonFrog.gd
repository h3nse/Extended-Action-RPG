extends KinematicBody2D

#States
enum {
	WANDER,
	CHASE
}
var state = WANDER
#Damage and hurt
func _process(delta):
	match state:
		WANDER:
			pass
		CHASE:
			pass
