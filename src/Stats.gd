extends Node

#Export so we can change it in editor
export(int) var max_health = 1 setget set_max_health
#setget calls the function set_health whenever health changes
var health = max_health setget set_health

#Create custom signal
signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	#Emit signal if health is <= 0
	if health <= 0:
		emit_signal("no_health")

func is_max_health():
	return health == max_health

func _ready():
	self.health = max_health
