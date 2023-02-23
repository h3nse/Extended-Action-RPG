extends Node2D

func _on_Area2D_body_entered(body):
	if !PlayerStats.is_max_health():
		PlayerStats.health = PlayerStats.max_health
		queue_free()
