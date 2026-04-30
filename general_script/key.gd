extends RigidBody3D

@export var use_collision: bool

var pos_obj

func _ready() -> void:
	if !use_collision:
		freeze = true
		
func _physics_process(delta: float) -> void:
	if pos_obj != null:
		global_transform.origin = pos_obj.global_transform.origin
		global_transform.origin.x = global_transform.origin.x + 0.15

func hit_obj(body):
	pos_obj = body
	freeze = true

func interact(interact_label, take_audio):
	interact_label.text = Global.pickup_text
	interact_label.visible = true
	if Input.is_action_just_pressed("interact"):
		take_audio.play()
		pickup_key()

func pickup_key():
	Global.hasBasementKey = true
	queue_free()
