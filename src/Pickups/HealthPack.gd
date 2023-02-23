extends Node2D


func _on_Area2D_body_entered(body):
	PlayerStats.health = PlayerStats.max_health
