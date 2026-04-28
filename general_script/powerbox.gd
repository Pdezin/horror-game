extends Node3D

var opened = false

func interact_powerbox(interact_label):
	if Input.is_action_just_pressed("interact"):
		toogle_powerbox()
	interact_label.visible = true
	
func interact_powerswitch(interact_label):
	if !Global.powerOn:
		if Input.is_action_just_pressed("interact"):
			toogle_powerswitch()
		interact_label.visible = true
	
func toogle_powerbox():
	if $AnimationPowerbox.current_animation == "open" or $AnimationPowerbox.current_animation == "close":
		return
		
	opened = !opened
	if !opened:
		$AnimationPowerbox.play("close")
		$close.play()
	if opened:
		$AnimationPowerbox.play("open")
		$open.play()
		
func toogle_powerswitch():
	if opened == false or Global.powerOn == true:
		return
	
	if $AnimationPowerbox.current_animation == "open" or $AnimationPowerbox.current_animation == "close" or $AnimationPowerswith.current_animation == "on":
		return
		
	Global.powerOn = true
	$AnimationPowerswith.play("on")
	$lever.play()
	await get_tree().create_timer(1.0, false).timeout
	$power.play()
	await get_tree().create_timer(1.0, false).timeout
	$power_buzz.play()
