extends Node3D


func open_safe():
	$pad.play()
	await get_tree().create_timer(3.0, false).timeout
	$open.play()
	$AnimationPlayer.play("open")
