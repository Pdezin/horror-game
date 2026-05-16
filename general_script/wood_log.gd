extends Node3D

func interact(interact_label):
	interact_label.text = Global.climb_text
	if Input.is_action_just_pressed("interact"):
		var spawn_point: Node3D = get_tree().current_scene.get_node("spawn_point")
		var player = get_tree().current_scene.get_node("player")
		player.transform.origin = spawn_point.transform.origin
	interact_label.visible = true
