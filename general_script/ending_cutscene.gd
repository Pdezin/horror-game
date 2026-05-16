extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_environment_settings($WorldEnvironment.environment)
	$cutscene_transition_ui/AnimationPlayer.play("fadeout")
	$AnimationPlayer.play("cutscene")
	$cutscene_credits/AnimationPlayer.play("fade")
	$car.init_cutscene()
	
	$car/AnimationPlayer.play("moving")
	await get_tree().create_timer(1.5, false).timeout
	$car/sounds/car_passes.play()
	$car/sounds/engine.play()
	#cutscene duration
	await get_tree().create_timer(12.5, false).timeout
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
