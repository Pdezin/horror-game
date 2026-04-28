extends Area3D

@export var level_name: String

func enter_trigger(body):
	if body != null and body.name == "player":
		get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")
		
