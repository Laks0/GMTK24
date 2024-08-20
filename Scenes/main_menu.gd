extends Control

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	DeathHandler.foods_obtained = []
	DeathHandler.last_checkpoint = ""

func _on_intro_finished():
	$Loop.play()
