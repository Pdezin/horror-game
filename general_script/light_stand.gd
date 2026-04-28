extends Node3D

@export var on = false

func _ready() -> void:
	$OmniLight3D.visible = on

func toggle_light():
	on = !on
	$OmniLight3D.visible = on
	$switch.play()
	
func interact(interact_label):
	if Global.powerOn:
		if Input.is_action_just_pressed("interact"):
			toggle_light()
	else:
		interact_label.text = Global.power_required_text
	interact_label.visible = true
