extends CharacterBody2D
class_name Cat

@export var gravity_acceleration : float = 980
@export var rat : Rata

@export var vision_distance : int = 300

@export var acceleration : float = 500
@export var patroll_speed : float = 100
@export var chase_speed : float = 700
@export var friction : float = 20

var patroll_dir : int = 1

var scale_factor : float = 1

func _physics_process(delta):
	scale = Vector2.ONE * scale_factor
	
	$VisionCast.target_position = position.direction_to(rat.position) * vision_distance
	
	if $VisionCast.get_collider() is Rata:
		follow_rat(delta)
	else:
		patroll(delta)
	
	velocity.y += gravity_acceleration * delta
	move_and_slide()

func follow_rat(delta):
	var dir = sign(rat.position.x - position.x)
	velocity.x += dir * acceleration * delta
	velocity.x = clamp(velocity.x, -chase_speed, chase_speed)
	
	if dir != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

func patroll(delta):
	if patroll_dir == 1 and not $RightFloorCast.is_colliding() and is_on_floor():
		patroll_dir = -1
	if patroll_dir == -1 and not $LeftFloorCast.is_colliding() and is_on_floor():
		patroll_dir = 1
	
	for cast : RayCast2D in $LeftWallCasts.get_children():
		if cast.is_colliding():
			patroll_dir = 1
			break
	
	for cast : RayCast2D in $RightWallCasts.get_children():
		if cast.is_colliding():
			patroll_dir = -1
			break
	
	velocity.x += patroll_dir * acceleration * delta
	velocity.x = clamp(velocity.x, -patroll_speed, patroll_speed)
	if patroll_dir != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
