extends Node2D

#Load grass effect scene once
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	#Make instance of the scene
	var grassEffect = GrassEffect.instance()
	#Add the instance in the world scene
	get_parent().add_child(grassEffect)
	#Set global_position of grass effect at global_position of grass
	grassEffect.global_position = global_position

	#When area entered, destroy grass
func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
