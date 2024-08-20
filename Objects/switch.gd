extends Area2D
class_name Switch

enum Activation {RAT, CAT}
@export var switch_type : Activation

enum Kind {SWITCH, VALVE}
@export var kind : Kind
var animation : AnimatedSprite2D

signal turned

func _on_body_entered(body):
	if switch_type == Activation.CAT and body is Cat:
		turned.emit()
	if switch_type == Activation.RAT and body is Rata:
		turned.emit()

func _ready():
	$Valve.visible = kind == Kind.VALVE
	$Switch.visible = kind == Kind.SWITCH
	animation = $Switch if kind == Kind.SWITCH else $Valve

func _on_turned():
	animation.play("ON")

func turn_off():
	animation.play_backwards("ON")
