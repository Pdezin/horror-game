extends CharacterBody3D

const WALK_SPEED = 2.0
const RUN_SPEED = 2.5

@export var patrol_destinations: Node3D
@export var growl_audios: Array[AudioStream]

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

func _ready() -> void:
	$monster_enemy/AnimationPlayer.play("idle")
	despawn_enemy()
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
	
func _process(delta: float) -> void:
	if chasing:
		if !$killcast/killcast.enabled:
			$killcast/killcast.enabled = true
		if chase_timer < 10.0:
			chase_timer += 1 * delta
		elif stop_chasing:
			stop_chasing = false
			chase_timer = 0
			chasing = false
			$killcast/killcast.enabled = false
			pick_destination()
	
	if idle or player_killed:
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

func pick_destination():
	if player_killed:
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
	active_enemy()

func update_target_location():
	if destination != null:
		$NavigationAgent3D.target_position = destination.global_transform.origin
	
func chase_player():
	if player_killed:
		return
		
	var playerFound = false
		
	for chasecast: RayCast3D in $chasecasts.get_children():
		if chasecast != null and chasecast.is_colliding():
			var hit = chasecast.get_collider()
			if hit.name == "player":
				playerFound = true
	
	if playerFound and !player_killed:
		stop_chasing = false
		chase_timer = 0
		chasing = true
		destination = player
		active_enemy()
	else:
		stop_chasing = true

func stop_enemy():
	idle = true
	speed = 0
	$monster_enemy/AnimationPlayer.play("idle")

func active_enemy():
	idle = false
	speed = WALK_SPEED
	$monster_enemy/AnimationPlayer.play("walking")
	
func kill_player():
	$killcast/killcast.look_at(player.global_transform.origin)
	if $killcast/killcast.is_colliding():
		var hit = $killcast/killcast.get_collider()
		if hit != null and player_killed == false and hit.name == "player":
			player_killed = true
			stop_growl()
			speed = 0
			player.visible = false
			player.get_node("player_ui").queue_free()
			player.process_mode = Node.PROCESS_MODE_DISABLED
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
	if player_killed:
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
