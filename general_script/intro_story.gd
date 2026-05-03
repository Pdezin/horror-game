extends Control

func _ready() -> void:
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(13.7, false).timeout
	change_scene()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://levels/level.tscn")
