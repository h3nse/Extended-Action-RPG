extends Area2D

#Variables
var player = null

#Return true wether player is null or not(we can't see them or we can
func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	player = null
