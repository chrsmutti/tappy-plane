extends Node


onready var sfx_player = AudioStreamPlayer.new()

func _ready():
	add_child(sfx_player)

func play(stream, volume_offset=0):
	if GameState.sfx_enabled:
		stream.set_loop(false)
		sfx_player.set_stream(stream)
		sfx_player.set_volume_db(-20 + volume_offset)
		sfx_player.play()