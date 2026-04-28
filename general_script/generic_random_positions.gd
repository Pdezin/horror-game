extends Node3D

func _ready() -> void:
	var children = get_children()
	if children.is_empty():
		return

	var chosen = children.pick_random()

	for child in children:
		if child != chosen:
			child.queue_free()
