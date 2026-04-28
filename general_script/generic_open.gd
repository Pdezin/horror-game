extends Node

var opened = false

func interact(interact_label):
	if Input.is_action_just_pressed("interact"):
		toogle_open()
	interact_label.visible = true
	
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
