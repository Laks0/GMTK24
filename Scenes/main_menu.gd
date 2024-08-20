extends Control

func _on_texture_button_pressed():
	$AudioStreamPlayer.play()
	DeathHandler.foods_obtained = []
	DeathHandler.last_checkpoint = ""

func _on_intro_finished():
	$Loop.play()

func _on_audio_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	Ost.play()

func _on_sfx_pressed():
	var idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(idx, not AudioServer.is_bus_mute(idx))

func _on_soundtrack_pressed():
	var idx = AudioServer.get_bus_index("OST")
	AudioServer.set_bus_mute(idx, not AudioServer.is_bus_mute(idx))
