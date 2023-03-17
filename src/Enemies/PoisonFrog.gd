extends KinematicBody2D

#export variables
export var maxJumpLength = 5.0
export var jumpInterval = 10.0
export var friction = 10
export var moveSpeed = 10

#Variables
onready var moveTimer = $MoveTimer
onready var jumpTimer = $JumpTimer
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var velocity = Vector2.ZERO

#States
enum {
	IDLE,
	JUMP,
	CHASE
}
var state = IDLE

func _ready():
	randomize()
	moveTimer.wait_time = rand_range(2.0, jumpInterval)

func _process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			animationTree.set("parameters/Idle/blend_position", velocity)
			animationState.travel("Idle")
		JUMP:
			velocity = move_and_slide(velocity)
			animationTree.set("parameters/Jump/blend_position", velocity)
			animationState.travel("Jump")
		CHASE:
			pass

func _on_MoveTimer_timeout():
	jumpTimer.start(rand_range(0.25, maxJumpLength))
	velocity = get_random_direction() * moveSpeed
	state = JUMP

func _on_JumpTimer_timeout():
	moveTimer.start(rand_range(1, jumpInterval))
	state = IDLE

func get_random_direction():
	var direction = Vector2(rand_range(-100,100), rand_range(-100,100))
	return direction.normalized()
