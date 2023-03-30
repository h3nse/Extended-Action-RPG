extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

#export variables
export var maxJumpLength = 5.0
export var jumpInterval = 10.0
export var friction = 200
export var moveSpeed = 10
export var softCollisionPushback = 250

#Variables
onready var moveTimer = $MoveTimer
onready var jumpTimer = $JumpTimer
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var softCollision = $SoftCollision
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var animationState = animationTree.get("parameters/playback")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var lastDirection = Vector2.ZERO

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
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if softCollision.is_colliding():
				velocity += softCollision.get_push_vector() * delta * softCollisionPushback
			velocity = move_and_slide(velocity)
			animationTree.set("parameters/Idle/blend_position", lastDirection)
			animationState.travel("Idle")
		JUMP:
			velocity = move_and_slide(velocity)
			animationTree.set("parameters/Jump/blend_position", velocity)
			animationState.travel("Jump")
			lastDirection = velocity
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
	#Creates vector and rotates it by a random degree
	var direction = Vector2.LEFT.rotated(rand_range(0,TAU))
	return direction

func _on_Hurtbox_area_entered(area):
	#Lower the health
	stats.health -= area.damage
	#Set knockback by direction and multiplier
	knockback = area.knockback_vector * 100
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("HitEffectStart")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("HitEffectStop")	

func _on_Stats_no_health():
	queue_free()
	#Make instance of scene
	var enemyDeathEffect = EnemyDeathEffect.instance()
	#Add scene to the world scene
	get_parent().add_child(enemyDeathEffect)
	#Set the position
	enemyDeathEffect.global_position = global_position
