extends Area3D

func entered_house_trigger(body: Node3D):
	if body != null and body.name == "player":
		var sounds: Node3D = get_tree().current_scene.get_node("ambient_sounds")
		for sound: AudioStreamPlayer3D in sounds.get_children():
			if sound.playing:
				sound.stop()
				
	if body != null and body.name == "player":
		var sounds: Node3D = get_tree().current_scene.get_node("house_ambient_sounds")
		for sound: AudioStreamPlayer3D in sounds.get_children():
			if !sound.playing:
				sound.play()
