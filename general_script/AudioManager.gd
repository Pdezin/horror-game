extends Node

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)

func play_music(stream: AudioStream):
	if player.stream != stream:
		player.stream = stream
		player.play()

func stop_music():
	player.stop()

func play_sound(stream: AudioStream):
	player.stream = stream
	player.play()
