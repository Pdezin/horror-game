extends Node3D

var opened = false
var locked = true
var isBusy = false

func toogle_open():
	if $AnimationPlayer.current_animation == "open":
		return
	
	opened = !opened
	if !opened:
		$AnimationPlayer.play_backwards("open")
		$close.play()
	if opened:
		$AnimationPlayer.play("open")
		$open.play()

func interact(interact_label):
	if isBusy:
		return
	
	isBusy = true
	
	if locked:
		if Global.chest_keys > 0:
			interact_label.text = Global.unlock_text
			interact_label.visible = true
			if Input.is_action_just_pressed("interact"):
				locked = false
				Global.chest_keys = Global.chest_keys - 1
				$unlock.play()
				await get_tree().create_timer(1.0, false).timeout
		else:
			interact_label.text = Global.locked_chest_text
	else:
		if !locked and Input.is_action_just_pressed("interact"):
			toogle_open()
	
	interact_label.visible = true
	isBusy = false
