extends StaticBody3D

@export var old_backyard: MeshInstance3D
@export var new_backyard: Node3D
@export var dig_sound: AudioStreamPlayer3D

var digged = false

func _process(delta: float) -> void:
	if digged:
		return
	
	if Global.hasShovel:
		$dig_collision.disabled = false
		set_disabled_new_backyard(false)
	else:
		$dig_collision.disabled = true
		set_disabled_new_backyard(true)

func interact(interact_label):
	if digged or !Global.hasShovel:
		return
	
	interact_label.text = Global.dig_text
	interact_label.visible = true
	
	if Input.is_action_just_pressed("interact"):
		dig()

func set_disabled_new_backyard(disabled: bool):
	new_backyard.get_node("dirt/StaticBody3D/CollisionShape3D").disabled = disabled
	new_backyard.get_node("hole/StaticBody3D/CollisionShape3D").disabled = disabled
	
func dig():
	$dig_collision.disabled = true
	digged = true
	Global.hasShovel = false
	
	dig_sound.play()
	
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadein_perma")
	await get_tree().create_timer(3.5, false).timeout
	
	old_backyard.visible = false
	new_backyard.visible = true
	new_backyard.get_node("chest").enabled = true
	new_backyard.get_node("shotgun").pickeable = true
	
	dig_sound.stop()
	get_tree().current_scene.get_node("player/player_ui/cutscene_transition_ui/AnimationPlayer").play("fadeout")
	await get_tree().create_timer(0.4, false).timeout
