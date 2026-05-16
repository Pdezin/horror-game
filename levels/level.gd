extends Node3D

func _ready() -> void:
	Global.set_environment_settings($WorldEnvironment.environment)
	Global.reseat_game()
	
func escape_cutscene():
	$player.hide_for_cutscene()
	$escape_cutscene/AnimationPlayer.play("escape")
	
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadeout")
	await get_tree().create_timer(0.5, false).timeout
	
	#$escape_cutscene/ending.play()
	var narration = preload("res://sounds/ending_music.mp3")
	AudioManager.play_sound(narration)
	
	await get_tree().create_timer(10.5, false).timeout
	
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein")
	#transition duration
	await get_tree().create_timer(0.8, false).timeout
	
	#change the scenery
	get_tree().change_scene_to_file("res://scenery/ending_cutscene.tscn")


func change_to_cam_1():
	$escape_cutscene/cam_1.current = true

func change_to_cam_2():
	$escape_cutscene/cam_2.current = true

func change_to_cam_3():
	$escape_cutscene/cam_3.current = true
