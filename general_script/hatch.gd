extends Node3D

var opened = false
var locked = true
var isBusy = false

func open_hatch():
	if opened:
		return
	
	if $AnimationPlayer.current_animation == "open":
		return
		
	opened = true
	Global.isBasementOpened = true
	Global.hasBasementKey = false
	$AnimationPlayer.play("open")
	$open.play()
	await get_tree().create_timer(2.0, false).timeout
	$hatch_area/hatch.disabled = true

func interact(interact_label):
	if isBusy or opened:
		return
	
	isBusy = true
	
	if locked:
		if Global.hasBasementKey:
			interact_label.text = Global.unlock_text
			interact_label.visible = true
			if Input.is_action_just_pressed("interact"):
				locked = false
				$unlock.play()
				await get_tree().create_timer(1.5, false).timeout
		else:
			interact_label.text = Global.locked_hatch_text
	else:
		if Global.hasBasementKey and Input.is_action_just_pressed("interact"):
			open_hatch()
	
	interact_label.visible = true
	isBusy = false
