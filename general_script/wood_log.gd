extends Node3D

func interact(interact_label):
	interact_label.text = Global.climb_text
	if Input.is_action_just_pressed("interact"):
		climb()
		
	interact_label.visible = true


func climb():
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein_perma")
	await get_tree().create_timer(0.4, false).timeout
	
	$old_wood.play()
	await get_tree().create_timer(2.5, false).timeout
	
	$old_wood.stop()
	await get_tree().create_timer(0.4, false).timeout
	
	$ground_hit.play()
	
	await get_tree().create_timer(0.4, false).timeout
	
	var spawn_point: Node3D = get_tree().current_scene.get_node("spawn_point")
	var player = get_tree().current_scene.get_node("player")
	player.global_transform.origin = spawn_point.global_transform.origin
		
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadeout")
	await get_tree().create_timer(0.4, false).timeout
