extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cutscene_transition_ui/AnimationPlayer.play("fadeout")
	$AnimationPlayer.play("cutscene")
	$cutscene_credits/AnimationPlayer.play("fade")
	$car/AnimationPlayer.play("moving")
	await get_tree().create_timer(1.5, false).timeout
	$car/sounds/car_passes.play()
	#cutscene duration
	await get_tree().create_timer(12.5, false).timeout
	get_tree().quit()
