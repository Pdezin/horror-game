extends CharacterBody3D

const WALK_SPEED = 2.0
const RUN_SPEED = 2.5

@export var patrol_destinations: Node3D
@export var growl_audios: Array[AudioStream]
@export var chase_music: AudioStreamPlayer

@onready var player = get_tree().current_scene.get_node("player")
@onready var rng = RandomNumberGenerator.new()

var speed = 2.0
var idle = false
var chasing = false
var stop_chasing = false
var chase_timer = 0.0
var destination
var destination_value
var player_killed = false
var player_hiding = false
var health := 6.0
var dead = false
var being_hiting = false

func _ready() -> void:
	$monster_enemy/AnimationPlayer.play("idle")
	despawn_enemy()
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
	
func _process(delta: float) -> void:
	if chasing:
		if !$killcast/killcast.enabled:
			$killcast/killcast.enabled = true
		if player_hiding:
			stop_chasing = false
			chase_timer = 0
			chasing = false
			$killcast/killcast.enabled = false
			pick_destination()
			await get_tree().create_timer(3.0, false).timeout
			stop_chase_music()
		elif chase_timer < 10.0:
			chase_timer += 1 * delta
		elif stop_chasing:
			stop_chasing = false
			chase_timer = 0
			chasing = false
			$killcast/killcast.enabled = false
			stop_chase_music()
			pick_destination()
	
	if idle or dead or being_hiting:
		if speed != 0:
			speed = 0
	elif chasing:
		if speed != RUN_SPEED:
			speed = RUN_SPEED
	else:
		if speed != WALK_SPEED:
			speed = WALK_SPEED
		
	#if destination != null and !idle:
	var look_dir = lerp_angle(deg_to_rad(global_rotation_degrees.y), atan2(-velocity.x, -velocity.z), 0.5)
	global_rotation_degrees.y = rad_to_deg(look_dir)
	update_target_location()

func _physics_process(delta: float) -> void:
	
	#chase control
	chase_player()
	kill_player()
	#fall control
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	
	#movement
	#if destination != null and !idle:
	var current_location = global_transform.origin
	var next_location = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	$NavigationAgent3D.set_velocity(new_velocity)
	#velocity = velocity.move_toward(new_velocity, 0.25)
	#move_and_slide()
	
	if speed > 0:
		footsteps()
	else:
		stop_footsteps()

func compute_velocity(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()

func spawn_enemy(node = null):
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	if node != null:
		global_transform.origin = node.global_transform.origin
		
	pick_destination()
	
func despawn_enemy():
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	chasing = false
	stop_chase_music()

func pick_destination():
	if player_killed or dead or being_hiting:
		return
	
	if chasing:
		return
	
	var destinations = available_patrol_destinations()
	var num = rng.randi_range(0, destinations.size() - 1)
	if destination_value != null and num == destination_value:
		if destination_value == (destinations.size() - 1):
			num = destination_value - 1
		else:
			num = destination_value + 1
		
	destination = destinations[num]
	destination_value = num
	print("Enemy destination:" + str(num))
	active_enemy()

func update_target_location():
	if destination != null:
		$NavigationAgent3D.target_position = destination.global_transform.origin
	
func chase_player():
	if player_killed or dead or being_hiting:
		return
		
	var playerFound = is_looking_at_player()
	
	if playerFound and !player_killed:
		init_chase()
	else:
		stop_chasing = true

func init_chase():
	stop_chasing = false
	chase_timer = 0
	chasing = true
	play_chase_music()
	destination = player
	active_enemy()

func is_looking_at_player():
	var playerFound = false
		
	for chasecast: RayCast3D in $chasecasts.get_children():
		if chasecast != null and chasecast.is_colliding():
			var hit = chasecast.get_collider()
			if hit.name == "player":
				playerFound = true
				
	return playerFound

func stop_enemy():
	idle = true
	speed = 0
	$monster_enemy/AnimationPlayer.play("idle")

func active_enemy():
	idle = false
	speed = WALK_SPEED
	$monster_enemy/AnimationPlayer.play("walking")
	
func kill_player():
	if dead or being_hiting:
		return
	
	$killcast/killcast.look_at(player.global_transform.origin)
	if $killcast/killcast.is_colliding():
		var hit = $killcast/killcast.get_collider()
		if hit != null and player_killed == false and hit.name == "player":
			player_killed = true
			stop_chasing = false
			chase_timer = 0
			chasing = false
			stop_growl()
			stop_chase_music()
			speed = 0
			player.hide_for_cutscene()
			$monster_enemy/jumpscare_cam.current = true
			$monster_enemy/AnimationPlayer.play("jumpscare")
			await get_tree().create_timer(4.5, false).timeout
			get_tree().change_scene_to_file("res://ui/death_screen_ui.tscn")
			
func available_patrol_destinations() -> Array[Node3D]:
	var available_destinations: Array[Node3D]
	var destinations_nodes = patrol_destinations.get_children()
	for node: Node3D in destinations_nodes:
		if node != null:
			if node.name == "house":
				available_destinations.append_array(node.get_children())
			if node.name == "outside":
				available_destinations.append_array(node.get_children())
			if node.name == "basement" and Global.isBasementOpened:
				available_destinations.append_array(node.get_children())
				
	return available_destinations

func footsteps():
	if isEnemyOnGrass():
		$feet/footsteps.stop()
			
		if !$feet/grass_footsteps.playing:
			$feet/grass_footsteps.play()
	else:
		$feet/grass_footsteps.stop()
			
		if !$feet/footsteps.playing:
			$feet/footsteps.play()

func stop_footsteps():
	if isEnemyOnGrass():
		$feet/footsteps.stop()
			
		if $feet/grass_footsteps.playing and $feet/grass_footsteps.get_playback_position() > 0.5:
			$feet/grass_footsteps.stop()
	else:
		$feet/grass_footsteps.stop()
			
		if $feet/footsteps.playing and $feet/footsteps.get_playback_position() > 0.5:
			$feet/footsteps.stop()
			
func isEnemyOnGrass() -> bool:
	if $feet/RayCast3D.is_colliding():
		var hit = $feet/RayCast3D.get_collider()
		if hit != null and hit.name == "grass":
			return true
			
	return false

func _on_timer_timeout():
	growl()
	$Timer.wait_time = randf_range(3.0, 10.0)

func growl():
	if player_killed or dead or being_hiting:
		stop_growl()
		return
	
	if $growl.playing:
		return
		
	var num = rng.randi_range(0, growl_audios.size() - 1)
	var audio = growl_audios[num]
	$growl.stream = audio
	$growl.play()
	
func stop_growl():
	if $growl.playing:
		$growl.stop()
		
func play_chase_music():
	if !chase_music.playing:
		chase_music.play()
	
func stop_chase_music():
	if chase_music.playing:
		chase_music.stop()
		
func take_damage(amount):
	if dead:
		return
		
	health -= amount
	speed = 0
	stop_footsteps()
	stop_growl()
	
	if health <= 0:
		dying()
	else:
		hit()
		
func dying():
	dead = true
	chasing = false
	$growl.play()
	$monster_enemy/AnimationPlayer.play("dying")
	$killcast/killcast.enabled = false
	$CollisionShape3D.disabled = true
	stop_chase_music()
	
func hit():
	look_at_player()
	
	being_hiting = true
	
	$monster_enemy/AnimationPlayer.play_backwards("dying")
	
	look_at_player()
	
	$monster_enemy/AnimationPlayer.seek(0.8)
	await get_tree().create_timer(0.7).timeout
	$monster_enemy/AnimationPlayer.stop()
	
	look_at_player()
	
	being_hiting = false
	init_chase()
	
func look_at_player():
	var direction = player.global_position - global_position
	direction.y = 0
	
	var look_dir = lerp_angle(
		deg_to_rad(global_rotation_degrees.y),
		atan2(-direction.x, -direction.z),
		0.5
	)

	global_rotation_degrees.y = rad_to_deg(look_dir)
