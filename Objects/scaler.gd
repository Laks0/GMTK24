extends Area2D
class_name Scaler

signal open
signal close

enum ScaleTypes {ENLARGE, REDUCE}
@export var scale_type : ScaleTypes

@export var switch  : Switch
@export var on_time : float = 5 

var on := false

@onready var water_stream_intro = $water_stream_intro
@onready var gas_stream_intro = $gas_stream_intro
@onready var water_stream_loop = $water_stream_loop
@onready var gas_stream_loop = $gas_stream_loop

func _ready():
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
		water_stream_intro.play()
		pass
	else:
		gas_stream_intro.play()
		pass
	on = true
	visible = true
	await get_tree().create_timer(on_time).timeout
	on = false
	visible = false


func _on_water_stream_intro_finished():
	water_stream_loop.play()

func _on_gas_stream_intro_finished():
	gas_stream_loop.play()
