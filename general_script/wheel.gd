extends MeshInstance3D

func interact(interact_label, take_audio):
	interact_label.text = Global.pickup_text
	interact_label.visible = true
	if Input.is_action_just_pressed("interact"):
		take_audio.play()
		pickup()

func pickup():
	Global.hasWheel = true
	queue_free()
