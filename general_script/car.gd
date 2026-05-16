extends Node3D

var wheel_installed = false
var isBusy = false

func init_cutscene():
	rotation.x = 0
	rotation.z = 0
	light_on()
	$install_wheel/install_wheel.disabled = true
	$SUV_FrontLeftWheel.visible = true

func interact(interact_label):
	if isBusy:
		return
	
	isBusy = true
	
	if wheel_installed:
		interact_label.text = Global.escape_text
		interact_label.visible = true
		if Input.is_action_just_pressed("interact"):
			$sounds/door.play()
			get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein")
			#transition duration
			await get_tree().create_timer(1.3, false).timeout
			
			get_tree().current_scene.escape_cutscene()
		
	isBusy = false
	
func light_on():
	$lights.visible = true
	
func start_car():
	$sounds/start.play()
	await get_tree().create_timer(0.5, false).timeout
	light_on()
	$AnimationPlayer.play("moving")
	
func interact_install_wheel(interact_label):
	if isBusy or wheel_installed:
		return
	
	isBusy = true
	
	if Global.hasWheel:
		interact_label.text = Global.install_wheel_text
		interact_label.visible = true
		if Input.is_action_just_pressed("interact"):
			install_wheel()
	else:
		interact_label.text = Global.need_wheel_text
		interact_label.visible = true
	
	isBusy = false

func install_wheel():
	$install_wheel/install_wheel.disabled = true
	$sounds/wrench_tool.play()
	
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein")
	await get_tree().create_timer(1.0, false).timeout
	
	$SUV_FrontLeftWheel.visible = true
	rotation.x = 0
	rotation.z = 0
	$car_support.free()
	
	await get_tree().create_timer(0.4, false).timeout
	
	
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadeout")
	await get_tree().create_timer(1.0, false).timeout
	
	wheel_installed = true
