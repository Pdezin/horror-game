extends Node3D

@export var light_1: Node3D
@export var light_2: Node3D
@export var light_3: Node3D
@export var light_4: Node3D
@export var light_5: Node3D
@export var door: Node3D
var puzzle_light_codes = 0
var puzzle_completed = false

func _ready() -> void:
	puzzle_light_codes = randi_range(1, 4)
	print("puzzle lights:" + str(puzzle_light_codes))
	
	if puzzle_light_codes == 1:
		$image.texture_albedo = load("res://textures/puzzle_1.png")
	elif puzzle_light_codes == 2:
		$image.texture_albedo = load("res://textures/puzzle_2.png")
	elif puzzle_light_codes == 3:
		$image.texture_albedo = load("res://textures/puzzle_3.png")
	elif puzzle_light_codes == 4:
		$image.texture_albedo = load("res://textures/puzzle_4.png")
		
	$panel_locked.visible = true
	$panel_unlocked.visible = false

func _process(delta: float) -> void:
	if puzzle_completed or not Global.powerOn:
		return
	
	door.locked = true
	
	#1 - kitchen, 2 - bedroom, 3 - bedroom2, 4 - bathroom, 5 - powerroom
	if puzzle_light_codes == 1:
		if light_1.on and not light_2.on and not light_3.on and light_4.on and light_5.on:
			door.locked = false
	elif puzzle_light_codes == 2:
		if not light_1.on and light_2.on and light_3.on and light_4.on and not light_5.on:
			door.locked = false
	elif  puzzle_light_codes == 3:
		if not light_1.on and light_2.on and light_3.on and not light_4.on and light_5.on:
			door.locked = false
	elif puzzle_light_codes == 4:
		if light_1.on and not light_2.on and light_3.on and not light_4.on and light_5.on:
			door.locked = false
		
	if door.locked == false:
		$panel_locked.visible = false
		$panel_unlocked.visible = true
	else:
		$panel_locked.visible = true
		$panel_unlocked.visible = false
