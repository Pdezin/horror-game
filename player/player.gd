extends CharacterBody3D

var SPEED = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("crouch"):
		crouching = !crouching
		stop_footsteps_crouching()
		
	if crouching and SPEED != 1.5:
		SPEED = 1.5
		
	if !crouching and SPEED != 3.5:
		SPEED = 3.5
	
func _physics_process(delta: float) -> void:
	# Crouching
	if crouching and scale.y > 0.6:
		var crouch_height = lerp(scale.y, 0.6, 0.1)
		scale.y = crouch_height
		
	if !crouching and scale.y < 1.0:
		var crouch_height = lerp(scale.y, 1.0, 0.1)
		scale.y = crouch_height
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			footsteps()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		stop_footsteps()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func footsteps():
	if crouching:
		return
	
	if isPlayerOnGrass():
		$feet/footsteps.stop()
			
		if !$feet/grass_footsteps.playing:
			$feet/grass_footsteps.play()
	else:
		$feet/grass_footsteps.stop()
			
		if !$feet/footsteps.playing:
			$feet/footsteps.play()

func stop_footsteps():
	if isPlayerOnGrass():
		$feet/footsteps.stop()
			
		if $feet/grass_footsteps.playing and $feet/grass_footsteps.get_playback_position() > 0.5:
			$feet/grass_footsteps.stop()
	else:
		$feet/grass_footsteps.stop()
			
		if $feet/footsteps.playing and $feet/footsteps.get_playback_position() > 0.5:
			$feet/footsteps.stop()

func stop_footsteps_crouching():
	$feet/footsteps.stop()
	$feet/grass_footsteps.stop()

func isPlayerOnGrass() -> bool:
	if $feet/RayCast3D.is_colliding():
		var hit = $feet/RayCast3D.get_collider()
		if hit != null and hit.name == "grass":
			return true
			
	return false

func hide_for_cutscene():
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	$player_ui/player_ui.visible = false
	$player_ui/task_ui.visible = false
