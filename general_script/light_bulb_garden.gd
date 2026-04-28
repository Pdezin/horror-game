extends Node3D

@export var blink = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideLight()
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
	
func _on_timer_timeout():
	if !Global.powerOn:
		hideLight()
		$Timer.wait_time = 5.0
		return
	
	if blink:
		var turnOn: bool = (randi_range(0, 3) > 0)
		if turnOn:
			$OmniLight3D.light_energy = randf_range(0.3, 1)
			showLight()
		else:
			hideLight()
			
		$Timer.wait_time = randf_range(0.1, 0.6)
	
	if !blink:
		showLight()
		$Timer.wait_time = 2.0
		
func showLight():
	$light.show()
	$light_off.hide()
	$OmniLight3D.visible = true
	
func hideLight():
	$light.hide()
	$light_off.show()
	$OmniLight3D.visible = false
