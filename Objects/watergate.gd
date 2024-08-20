extends Node2D

func _ready():
	get_parent().open.connect(open)
	get_parent().close.connect(close)

func open():
	$Door.play("Open")
	$Stream.play("Fall")
	create_tween().tween_property($Stream, "modulate:a", 1, .5)
	$GPUParticles2D.emitting = true

func close():
	$Door.play_backwards("Open")
	create_tween().tween_property($Stream, "modulate:a", 0, .5)
