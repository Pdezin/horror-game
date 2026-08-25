extends Area3D

var triggered = false

@export var function: Callable

func enter_trigger(body):
	if body != null and body.name == "player" and !triggered:
		triggered = true
		if function.is_valid():
			function.call()
		
