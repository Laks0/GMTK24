extends Control

var finished := false

func _ready():
	Ost.stop()

func _on_animation_finished():
	var tween := create_tween()
	tween.tween_property($Control, "scale", Vector2.ONE * 77, 2)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Label, "modulate:a", 1, .5)
	tween.tween_interval(1)
	tween.tween_property($Credits, "modulate:a", 1, 1)
	tween.tween_callback(func(): finished = true)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and finished:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_intro_finished():
	$Loop.play()


func _on_control_frame_changed() -> void:
	if $Control.frame == 3:
		$nom.play()
	if $Control.frame == 4:
		$wow.play()
