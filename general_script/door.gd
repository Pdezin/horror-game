extends Node3D

@export var custom_material: StandardMaterial3D
@export var locked = false
@export var puzzle: Node3D

var opened = false

func _physics_process(delta: float) -> void:
	if !opened and !locked and has_enemy_in_area():
		toogle_door(true)
	
func interact(interact_label):
	if has_enemy_in_area():
		return
		
	if Input.is_action_just_pressed("interact"):
		toogle_door(false)
	if locked:
		interact_label.text = Global.locked_door_text
	interact_label.visible = true
	
func toogle_door(fastAnimation: bool):
	if locked:
		return
	
	if $AnimationPlayer.current_animation in "open":
		return
	
	opened = !opened
	if !opened:
		$door_frame/close.play()
		if fastAnimation:
			$AnimationPlayer.play_backwards("open_fast")
		else:
			$AnimationPlayer.play_backwards("open")
	if opened:
		$door_frame/open.play()
		if puzzle != null:
			puzzle.puzzle_completed = true
		if fastAnimation:
			$AnimationPlayer.play("open_fast")
		else:
			$AnimationPlayer.play("open")
		
func ai_open_door(body):
	if body != null and opened == false and body.name == "enemy":
		toogle_door(false)
		
func ai_close_door(body):
	pass
	#if body != null and opened == true and body.name == "enemy":
		#toogle_door()
		
func has_enemy_in_area() -> bool:
	for body in $Area3D.get_overlapping_bodies():
		if body.name == "enemy":
			return true
	return false

func _ready() -> void:
	if custom_material != null:
		$door_frame.material_override = custom_material
		$frames/frame1.material_override = custom_material
		$frames/frame2.material_override = custom_material
		$frames/frame3.material_override = custom_material
