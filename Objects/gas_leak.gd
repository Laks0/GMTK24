extends Area2D
class_name GasLeak

func _on_body_entered(body):
	body.reduce()
