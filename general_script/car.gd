extends Node3D

func interact(interact_label):
	interact_label.visible = true
	if Input.is_action_just_pressed("interact"):
		get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein")
		#transition duration
		await get_tree().create_timer(1.0, false).timeout
		#change the scenery
		get_tree().change_scene_to_file("res://scenery/ending_cutscene.tscn")
		
