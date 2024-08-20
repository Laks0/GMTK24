extends Area2D
class_name Scaler

signal open
signal close

enum ScaleTypes {ENLARGE, REDUCE}
@export var scale_type : ScaleTypes

@export var switch  : Switch
@export var on_time : float = 5 



var on := false

@onready var water_stream_loop = $water_stream_loop
@onready var gas_stream_loop = $gas_stream_loop

func _ready():
	water_stream_loop.set_volume_db(linear_to_db(0.1))
	gas_stream_loop.set_volume_db(linear_to_db(0.1))
	if is_instance_valid(switch):
		switch.turned.connect(turn_on)

func _on_body_entered(body):
	if not on:
		return
	if not body is Cat:
		return
	
	if scale_type == ScaleTypes.ENLARGE:
		body.enlarge()
	else:
		body.reduce()

func turn_on():
	if scale_type==ScaleTypes.ENLARGE:
		$water_stream_loop.play()
		create_tween().tween_property($water_stream_loop,"volume_db",linear_to_db(1.0),1.0)
	else:
		$gas_stream_loop.play()
		create_tween().tween_property($gas_stream_loop,"volume_db",linear_to_db(1.0),1.0)
	
	on = true
	open.emit()
	$Timer.start(on_time)
	
	for body in get_overlapping_bodies():
		_on_body_entered(body)

#TODO:SOLO LOOP PERO CON UN FADE IN Y CON FADE OUT 2

func _on_timer_timeout():
	create_tween().tween_property($gas_stream_loop,"volume_db",-100.0,3.0)
	create_tween().tween_property($water_stream_loop,"volume_db",-100.0,3.0)
	on = false
	close.emit()
