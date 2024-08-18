extends CharacterBody2D
class_name Cat

@export var gravity_acceleration : float = 980
@export var rat : Rata

@export var vision_distance : int = 300

@export var acceleration : float = 500
@export var patroll_speed : float = 100
@export var chase_speed : float = 700
@export var friction : float = 20

@export var max_height_vision_distance : float = 32

@export var cat_height : int = 64

var patroll_dir : int = 1

var scale_factor : float = 1

var chasing := false

var size_tween : Tween = null

func _physics_process(delta):
	$VisionCast.target_position = position.direction_to(rat.position) * vision_distance
	
	if chasing:
		follow_rat(delta)
	else:
		patroll(delta)
	
	velocity.y += gravity_acceleration * delta
	move_and_slide()

func follow_rat(delta):
	if not can_see_rat():
		loose_focus()
		return
	
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
	
	# Detección de la rata
	if can_see_rat():
		chasing = true

func loose_focus():
	await get_tree().create_timer(2).timeout
	chasing = false

func can_see_rat() -> bool:
	if (not $VisionCast.is_colliding()) or (not $VisionCast.get_collider() is Rata):
		return false
	if abs(rat.position.y - position.y) > max_height_vision_distance:
		return false
	return true

var scale_time : float = .1

func enlarge():
	scale_factor = 2
	
	start_size_animation()

func reduce():
	scale_factor = .5
	
	start_size_animation()

func start_size_animation():
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", scale_factor * Vector2.ONE, scale_time)
