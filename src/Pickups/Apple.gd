extends Node2D
export var health_increase = 1

func _on_Area2D_body_entered(body):
	if !PlayerStats.is_max_health():
		PlayerStats.health += health_increase
		queue_free()
