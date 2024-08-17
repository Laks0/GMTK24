extends Area2D
class_name Funnel

func _on_body_entered(body):
	if body is Cat:
		var dir = sign(body.velocity.x)
		if dir == -1:
			body.scale_factor *= .5
		else:
			body.scale_factor *= 2
		body.position.x += dir * 64 * body.scale_factor
