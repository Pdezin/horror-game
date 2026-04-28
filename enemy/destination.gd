extends Node3D

@onready var rng = RandomNumberGenerator.new()

func enter_trigger(body):
	if body != null and body.name == "enemy" and body.destination == self:
		body.stop_enemy()
		await get_tree().create_timer(randf_range(1.0, 10.0), false).timeout
		body.pick_destination()
