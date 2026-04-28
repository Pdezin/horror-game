extends RigidBody3D

@export var use_collision: bool

var pos_obj

func _ready() -> void:
	if !use_collision:
		freeze = true
		
	$code_text.mesh.text = Global.safe_password

func _physics_process(delta: float) -> void:
	if pos_obj != null:
		global_transform.origin = pos_obj.global_transform.origin
		global_transform.origin.x = global_transform.origin.x - 0.15

func hit_obj(body):
	pos_obj = body
	freeze = true
