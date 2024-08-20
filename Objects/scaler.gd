extends Area2D
class_name Scaler

signal open
signal close

enum ScaleTypes {ENLARGE, REDUCE}
@export var scale_type : ScaleTypes

@export var switch  : Switch
@export var on_time : float = 5 

var on := false

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
	on = true
	open.emit()
	await get_tree().create_timer(on_time).timeout
	on = false
	switch.turn_off()
	close.emit()
