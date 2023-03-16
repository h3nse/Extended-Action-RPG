extends Node2D

func _ready():
	$YSort/Pickups/Firesword.connect("weapon_pickup", $YSort/Player, "weapon_picked_up")
	$YSort/Player.connect("cycled_weapon",$UI/WeaponUI,"on_weapon_cycle")
	$UI/WeaponUI.texture = load("res://Weapons/" + $YSort/Player.weapon_array[0] + "Pickup.png")
