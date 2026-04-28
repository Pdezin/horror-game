extends Control

func _ready() -> void:
	$eating.play()
	$AnimationPlayer.play("death")
	await get_tree().create_timer(4.5, true).timeout
	
	get_tree().quit()
