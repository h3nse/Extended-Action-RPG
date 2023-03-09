extends Node2D

signal weapon_pickup

func _on_Area2D_body_entered(body):
	emit_signal("weapon_pickup", "FIRESWORD")
	queue_free()
