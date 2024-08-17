extends RigidBody2D
class_name Funnel

func _physics_process(delta):
	if not $Cooldown.is_stopped():
		return
	
	if $BigSideCast.is_colliding() and $BigSideCast.get_collider() is Cat:
		var cat := $BigSideCast.get_collider() as Cat
		cat.scale_factor *= .5
		cat.position.x = global_position.x - cat.scale_factor * 64 + 16
		cat.position.y += 32 * cat.scale_factor
		$Cooldown.start()
	
	if $SmallSideCast.is_colliding() and $SmallSideCast.get_collider() is Cat:
		var cat := $SmallSideCast.get_collider() as Cat
		cat.scale_factor *= 2
		cat.position.x = global_position.x + cat.scale_factor * 64 + 16
		$Cooldown.start()
