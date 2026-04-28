extends Node

@onready var rng = RandomNumberGenerator.new()

const interact_text = 'Press "E" to interact'
const power_required_text = 'Turn on the power before'
const locked_door_text = 'The door is locked'
const locked_hatch_text = 'The hatch is locked'
const unlock_text = 'Press "E" to unlock'
const pickup_text = 'Press "E" to pick up'

var powerOn = false
var hasBasementKey = false
var isBasementOpened = false
var safe_interactable = true
var playerOnGrass = false

@onready var safe_password = generate_safe_password()

func generate_safe_password() -> String:
	var password = str(rng.randi_range(1000, 9999))
	print("password:" + password)
	return password
