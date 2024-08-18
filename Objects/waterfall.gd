extends Area2D
class_name Waterfall

func _on_body_entered(body):
	if not body is Cat:
		return
	
	body.enlarge()
