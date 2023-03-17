extends KinematicBody2D

#export variables
export var maxJumpLength = 5
export var jumpInterval = 10
export var friction = 10
export var moveSpeed = 10

#Variables
onready var moveTimer = $MoveTimer
onready var jumpTimer = $JumpTimer

var velocity = Vector2.ZERO

#States
enum {
	IDLE,
	JUMP,
	CHASE
}
var state = IDLE

func _ready():
	moveTimer.wait_time = rand_range(2, 10)

func _process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		JUMP:
			velocity = move_and_slide(velocity)
		CHASE:
			pass

func _on_MoveTimer_timeout():
	jumpTimer.start(rand_range(1, maxJumpLength))
	velocity = get_random_direction() * moveSpeed
	state = JUMP

func _on_JumpTimer_timeout():
	moveTimer.start(rand_range(1, jumpInterval))
	state = IDLE

func get_random_direction():
	var direction = Vector2(rand_range(-100,100), rand_range(-100,100))
	return direction.normalized()
