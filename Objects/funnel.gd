extends RigidBody2D
class_name Funnel

func _physics_process(delta):
	if not $Cooldown.is_stopped():
		return
	
	if $BigSideCast.is_colliding() and $BigSideCast.get_collider() is Cat:
		var cat := $BigSideCast.get_collider() as Cat
		cat.scale_factor *= .5
		var distance : float = 64 * cat.scale_factor + 16
		cat.position.x = to_global($SmallSideMarker.position * distance).x
		cat.position.y += 32 * cat.scale_factor
		$Cooldown.start()
	
	if $SmallSideCast.is_colliding() and $SmallSideCast.get_collider() is Cat:
		var cat := $SmallSideCast.get_collider() as Cat
		cat.scale_factor *= 2
		var distance : float = 64 * cat.scale_factor + 16
		cat.position.x = to_global($BigSideMarker.position * distance).x
		$Cooldown.start()
