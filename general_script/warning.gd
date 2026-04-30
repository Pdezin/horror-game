extends Control


func _ready() -> void:
	$CanvasLayer/AnimationPlayer.play("fade")
	await get_tree().create_timer(7.5, false).timeout
	get_tree().change_scene_to_file("res://levels/level.tscn")
	
