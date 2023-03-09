extends Node2D

func _ready():
	$YSort/Pickups/Firesword.connect("weapon_pickup", $YSort/Player, "weapon_picked_up")
