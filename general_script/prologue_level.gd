extends Node3D

func _ready() -> void:
	Global.set_environment_settings($WorldEnvironment.environment)
	$enemy.spawn_enemy()
