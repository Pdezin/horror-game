extends RayCast3D

@export var take_audio: AudioStreamPlayer3D
@export var playerUI: Control
@onready var interact_label = playerUI.get_node("player_ui/interact_text/Label")

func _physics_process(_delta: float) -> void:
	interact_label.visible = false
	interact_label.text = Global.interact_text
	
	if is_colliding():
		var hit = get_collider()
		
		if "light_stand" in hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "light_switch" in hit.name:
			hit.get_parent().interact(interact_label)
		elif "door" in hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "hatch" in hit.name:
			hit.get_parent().interact(interact_label)
		elif "chest_key" in hit.name:
			hit.interact(interact_label, take_audio)
		elif "key" in hit.name:
			hit.interact(interact_label, take_audio)
		elif "powerbox" in hit.name:
			hit.get_parent().get_parent().get_parent().interact_powerbox(interact_label)
		elif "power_switch" in hit.name:
			hit.get_parent().get_parent().interact_powerswitch(interact_label)
		elif "drawer" in hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "bookcase" in hit.name:
			hit.get_parent().interact(interact_label)
		elif "chest" in hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "safe" in hit.name:
			if Global.safe_interactable:
				if Input.is_action_just_pressed("interact"):
					playerUI.open_safe_password()
				interact_label.visible = true
		elif "car" == hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "wood_log" == hit.name:
			hit.get_parent().get_parent().interact(interact_label)
		elif "wheel" == hit.name:
			hit.get_parent().interact(interact_label, take_audio)
		elif "shovel" == hit.name:
			hit.get_parent().get_parent().interact(interact_label, take_audio)
		elif "shotgun" == hit.name:
			hit.get_parent().get_parent().interact(interact_label, take_audio)
		elif "install_wheel" == hit.name:
			hit.get_parent().interact_install_wheel(interact_label)
		elif "enter_closet" == hit.name:
			hit.get_parent().interact_enter(interact_label)
		elif "exit_closet" == hit.name:
			hit.get_parent().interact_exit(interact_label)
		elif "dig" == hit.name:
			hit.interact(interact_label)
