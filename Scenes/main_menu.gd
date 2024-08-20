extends Control
var is_OST_muted:bool=false
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
	#AUDIO SERVER NO ESTARIA FUNCIONANDO
	if is_OST_muted:
		is_OST_muted=false
		$Intro.set_volume_db(linear_to_db(1.0))
		$Loop.set_volume_db(linear_to_db(1.0))
	else:
		is_OST_muted=true
		$Intro.set_volume_db(linear_to_db(0.0))
		$Loop.set_volume_db(linear_to_db(0.0))
