extends KinematicBody2D

#export variables
export var jumpLength = 1000

#Variables
onready var MoveTimer = $MoveTimer

var velocity = Vector2.ZERO

#States
enum {
	WANDER,
	CHASE
}
var state = WANDER

func _process(delta):
	match state:
		WANDER:
			_on_MoveTimer_timeout()
		CHASE:
			pass

func _on_MoveTimer_timeout():
	velocity = get_random_direction() * jumpLength
	velocity = move_and_slide(velocity)
	MoveTimer.start(rand_range(2,10))

func get_random_direction():
	var direction = Vector2(rand_range(-100,100), rand_range(-100,100))
	return direction.normalized()
