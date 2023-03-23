extends KinematicBody2D

#Load once
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

#Make variables
export var acceleration = 300
export var max_speed = 50
export var friction = 200

#State machine
enum {
	IDLE,
	WANDER,
	CHASE
}

#Make variables
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var lastDirection = Vector2.ZERO

#Set loaded state to IDLE
var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wander_controller = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	#Always moves knockback towards zero(friction)
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	#Makes the bat move when knockback is not zero
	knockback = move_and_slide(knockback)
	
	#Identify which state we're in and run appropriate code
	match state:
		IDLE:
			#move velocity towards zero and seek player
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
				
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 5:
				update_wander()
			lastDirection = velocity
		CHASE:
			#Link player variable
			var player = playerDetectionZone.player
			#If player is within radius
			if player != null:
				#the direction is the difference in the 2 positions
				accelerate_towards_point(player.global_position, delta)
			else:
				#Switch to IDLE when we lose sight of player
				state = IDLE
			lastDirection = velocity
	
	#Flip to face the correct way
	sprite.flip_h = lastDirection.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	#Move and remember new vector
	velocity = move_and_slide(velocity)

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

func seek_player():
	#If we can see the player, change state to CHASE
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

	#area = the area that entered
func _on_Hurtbox_area_entered(area):
	#Lower the health
	stats.health -= area.damage
	#Set knockback by direction and multiplier
	knockback = area.knockback_vector * 100
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	queue_free()
	#Make instance of scene
	var enemyDeathEffect = EnemyDeathEffect.instance()
	#Add scene to the world scene
	get_parent().add_child(enemyDeathEffect)
	#Set the position
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
