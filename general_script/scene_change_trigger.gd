extends Area3D

@export var level_name: String

func enter_trigger(body):
	if body != null and body.name == "player":
		body.get_node("player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein")
		#transition duration
		await get_tree().create_timer(1.0, false).timeout
		#change the scenery
		get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")
		
