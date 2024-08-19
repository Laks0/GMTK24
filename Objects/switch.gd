extends Area2D
class_name Switch

enum Activation {RAT, CAT}
@export var switch_type : Activation

signal turned

func _on_body_entered(body):
	if switch_type == Activation.CAT and body is Cat:
		turned.emit()
	if switch_type == Activation.RAT and body is Rata:
		turned.emit()
