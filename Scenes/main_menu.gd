extends Control

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")

func _on_intro_finished():
	$Loop.play()
