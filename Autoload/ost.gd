extends AudioStreamPlayer

@export var loop : AudioStream

func _on_finished():
	stream = loop
	play()
