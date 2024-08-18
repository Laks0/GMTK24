extends StaticBody2D
class_name BreakableWall

func _on_area_2d_body_entered(body):
	if not body is Cat:
		return
	
	if body.chasing:
		queue_free()
