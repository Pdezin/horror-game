extends Node

@onready var rng = RandomNumberGenerator.new()
@onready var safe_password = generate_safe_password()

const interact_text = 'Press "E" to interact'
const power_required_text = 'Turn on the power before'
const locked_door_text = 'The door is locked'
const locked_chest_text = 'The chest is locked'
const locked_hatch_text = 'The hatch is locked'
const need_wheel_text = 'It looks like a wheel is missing'
const climb_text = 'Press "E" to climb'
const unlock_text = 'Press "E" to unlock'
const pickup_text = 'Press "E" to pick up'
const install_wheel_text = 'Press "E" to place the wheel'
const escape_text = 'Press "E" to escape'
const hide_text = 'Press "E" to hide'
const exit_text = 'Press "E" to exit'
const dig_text = 'Press "E" to start digging'
const closet_cant_open = "You can't, the creature is too close"

var powerOn = false
var hasFlashlight = true
var hasShootgun = false
var hasWheel = false
var hasShovel = false
var hasBasementKey = false
var isBasementOpened = false
var safe_interactable = true
var playerOnGrass = false
var chest_keys = 0

func reseat_game():
	powerOn = false
	hasFlashlight = true
	hasShootgun = false
	hasWheel = false
	hasShovel = false
	hasBasementKey = false
	isBasementOpened = false
	safe_interactable = true
	playerOnGrass = false
	chest_keys = 0

func generate_safe_password() -> String:
	var password = str(rng.randi_range(1000, 9999))
	print("password:" + password)
	return password

#SETTINGS
var camera_sensitivity = 0.2
var ssil_enabled = false
var glow_enabled = false
var volumetric_fog_enabled = false

func set_environment_settings(environment: Environment):
	if environment == null:
		return
	
	environment.ssil_enabled = ssil_enabled
	environment.glow_enabled = glow_enabled
	environment.volumetric_fog_enabled = volumetric_fog_enabled
