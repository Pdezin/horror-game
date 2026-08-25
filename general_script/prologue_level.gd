extends Node3D

func _ready() -> void:
	Global.set_environment_settings($WorldEnvironment.environment)
	$monster_cutscene/function_trigger.function = start_monster_cutscene

func start_monster_cutscene():
	$player.hide_for_cutscene()
	$monster_cutscene/AnimationPlayer.play("monster_cutscene")
	$monster_cutscene/Camera3D.make_current()

func end_monster_cutscene():
	$player.global_position = Vector3(15.106, 0.509, 1.8)
	$player.global_rotation_degrees = Vector3(0.0, 124.8, 0.0)
	$monster_cutscene/Camera3D.clear_current()
	$player.show_end_cutscene()
	$enemy.spawn_enemy()
	var ui = get_tree().current_scene.get_node("player/player_ui")
	ui.set_task(Global.run_jumpscare)
