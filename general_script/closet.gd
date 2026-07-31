extends Node3D

@onready var player = get_tree().current_scene.get_node("player")
@onready var enemy = get_tree().current_scene.get_node("enemy")
@onready var playerCamera: Camera3D = get_tree().current_scene.get_node("player/head/Camera3D")

func interact_enter(interact_label):
	if (enemy.is_looking_at_player()):
		interact_label.text = Global.closet_cant_open
		interact_label.visible = true
		return
	
	interact_label.text = Global.hide_text
	interact_label.visible = true
	
	if Input.is_action_just_pressed("interact"):
		enter()
		
func interact_exit(interact_label):
	interact_label.text = Global.exit_text
	interact_label.visible = true
	
	if Input.is_action_just_pressed("interact"):
		exit()
		
func enter():
	if $AnimationPlayer.current_animation == "hide":
		return
	
	$enter_closet/enter_closet.disabled = true
	$exit_closet/exit_closet.disabled = true
	
	$Camera3D.current = true
	player.global_transform.origin = $enter_position.global_transform.origin
	
	player.disable_movement = true
	player.hide_for_cutscene()
	$AnimationPlayer.play("hide")
	
	$open.play()
	await await get_tree().create_timer(1.2, false).timeout
	
	$close.play()
	await await get_tree().create_timer(1.8, false).timeout
	
	player.rotate_y(185)
	playerCamera.make_current()
	player.show_end_cutscene()
	enemy.player_hiding = true
	
	$enter_closet/enter_closet.disabled = false
	$exit_closet/exit_closet.disabled = false

func exit():
	if $AnimationPlayer.current_animation == "hide":
		return
	
	$enter_closet/enter_closet.disabled = true
	$exit_closet/exit_closet.disabled = true
	
	$Camera3D.current = true
	player.global_transform.origin = $exit_position.global_transform.origin
	
	player.hide_for_cutscene()
	$AnimationPlayer.play_backwards("hide")
	
	$open.play()
	await await get_tree().create_timer(1.2, false).timeout
	
	$close.play()
	await await get_tree().create_timer(1.8, false).timeout
	
	player.rotate_y(185)
	playerCamera.make_current()
	player.show_end_cutscene()
	player.disable_movement = false
	
	enemy.player_hiding = false
	
	$enter_closet/enter_closet.disabled = false
	$exit_closet/exit_closet.disabled = false

func play_open():
	$open.play()
	
func play_close():
	$close.play()
