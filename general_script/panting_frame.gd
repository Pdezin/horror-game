extends Node3D

@export var painting: StandardMaterial3D

func _ready() -> void:
	$Plane.material_override = painting
