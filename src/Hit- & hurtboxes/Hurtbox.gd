extends Area2D

#Load the effect once
const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collision_shape_2d = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	#Create instance of effect
	var effect = HitEffect.instance()
	#Get access to the scene we're in
	var main = get_tree().current_scene
	#Add the effect to that scene
	main.add_child(effect)
	#Set the position
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	collision_shape_2d.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	collision_shape_2d.disabled = false
