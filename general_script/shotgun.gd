extends Node3D

var damage: float = 1.0
var fire_delay: float = 1.0
@export var pickeable: bool = false
@export var ammo: Node3D

@export var raycast: RayCast3D

var can_shoot := true

func interact(interact_label, take_audio):
	if not pickeable:
		return
		
	interact_label.text = Global.pickup_text
	interact_label.visible = true
	if Input.is_action_just_pressed("interact"):
		take_audio.play()
		pickup()

func pickup():
	Global.hasShotgun = true
	if ammo != null:
		ammo.visible = false
	queue_free()

func _process(_delta):
	if not pickeable:
		$shotgun/shotgun/shotgun.disabled = true
	else:
		$shotgun/shotgun/shotgun.disabled = false
		
	if pickeable:
		return
		
	if Global.hasShotgun and Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if Global.hasShotgun == false:
		return
		
	if pickeable or not visible or not can_shoot:
		return

	can_shoot = false
	
	$AnimationPlayer.play("shot")
	
	$fire/GPUParticles3D.top_level = false
	$fire/GPUParticles3D.restart()
	$fire.visible = true
	$shot.play()
	
	await get_tree().create_timer(0.3).timeout
	$fire.visible = false
	
	# Shoot
	if raycast.is_colliding():
		var target = raycast.get_collider()

		if target.has_method("take_damage"):
			target.take_damage(damage)

	await get_tree().create_timer(0.7).timeout
	
	$reload.play()

	# Wait before allowing another shot
	await get_tree().create_timer(fire_delay).timeout

	can_shoot = true
