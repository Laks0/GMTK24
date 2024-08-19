extends StaticBody2D
class_name BreakableWall

func _process(_delta):
	if $RayCast2D.enabled and $RayCast2D.is_colliding() and not $RayCast2D.get_collider() is BreakableWall:
		$TopSprite.visible = false
		$BaseSprite.visible = true
	$RayCast2D.enabled = false

func _on_area_2d_body_entered(body):
	if not body is Cat:
		return
	
	if body.chasing:
		$Area2D.set_deferred("monitoring", false)
		$CollisionShape2D.set_deferred("disabled", true)
		$BaseSprite.visible = false
		$TopSprite.visible = false
		$GPUParticles2D.emitting = true

func _on_gpu_particles_2d_finished():
	queue_free()
