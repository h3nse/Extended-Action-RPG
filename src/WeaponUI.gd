extends TextureRect

func _ready():
	pass

func on_weapon_cycle(weapon):
	texture = load("res://Weapons/" + weapon + "Pickup.png")
