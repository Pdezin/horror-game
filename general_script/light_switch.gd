extends Node3D

@export var on = false
@export var on_mat = StandardMaterial3D
@export var off_mat = StandardMaterial3D
@export var light_bulb: Node3D

func _ready() -> void:
	if !on:
		light_bulb.get_node("light").material_override = off_mat
	if on:
		light_bulb.get_node("light").material_override = on_mat
	
	light_bulb.get_node("OmniLight3D").visible = on
	
	$on.visible = on
	$off.visible = !on

func interact(interact_label):
	if Global.powerOn == true:
		if Input.is_action_just_pressed("interact"):
			toggle_light()
			$switch.play()
	else:
		interact_label.text = Global.power_required_text
	interact_label.visible = true
		
func toggle_light():
	on = !on
	
	if on:
		$on.visible = true
		$off.visible = false
		light_bulb.get_node("light").material_override = on_mat
	if !on:
		$on.visible = false
		$off.visible = true
		light_bulb.get_node("light").material_override = off_mat
		
	light_bulb.get_node("OmniLight3D").visible = on
