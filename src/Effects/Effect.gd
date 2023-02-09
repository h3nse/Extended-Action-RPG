extends AnimatedSprite

func _ready():
	#First self is Object that has the signal, the parameters are(The signal to connect to, the object that has the function, the function we're connecting to
	self.connect("animation_finished", self, "_on_animation_finished")
	#Set starting frame to 0 and play animation
	play("Animate")

#When getting signal that animation has ended, remove grass effect
func _on_animation_finished():
	queue_free()
