extends Node3D

@export var locked = true
@export var enabled = true;
@export var custom_material: StandardMaterial3D
var opened = false
var isBusy = false

func _ready() -> void:
	if custom_material != null:
		$ChestBottom.material_override = custom_material
		$ChestTop.material_override = custom_material
		$cover.visible = true

func _process(_delta):
	if not enabled:
		$ChestBottom/chest/CollisionShape3D.disabled = true
		$ChestTop/chest/CollisionShape3D.disabled = true
	else:
		$ChestBottom/chest/CollisionShape3D.disabled = false
		$ChestTop/chest/CollisionShape3D.disabled = false
		
		
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
