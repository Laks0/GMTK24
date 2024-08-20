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

@export var transition_duration = 1.00
@export var transition_type = 1 # TRANS_SINE
var tween_out =get_tree().create_tween()

func _ready():
	water_stream_loop.set_volume_db(linear_to_db(0.1))
	water_stream_intro.set_volume_db(linear_to_db(0.1))
	gas_stream_loop.set_volume_db(linear_to_db(0.1))
	gas_stream_intro.set_volume_db(linear_to_db(0.1))
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
	open.emit()
	await get_tree().create_timer(on_time).timeout
	$water_stream_loop.stop()
	$gas_stream_loop.stop()
	on = false
	visible = false

#TODO:SOLO LOOP PERO CON UN FADE IN Y CON FADE OUT 
func _on_water_stream_intro_finished():
	water_stream_loop.play()

func _on_gas_stream_intro_finished():
	gas_stream_loop.play()

func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	tween_out.interpolate_property
	# when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
