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
@onready var animated_sprite : AnimatedSprite2D = $animated_sprite

@onready var idle_stream = $idle_stream
@onready var chase_stream = $chase_stream

var rng = RandomNumberGenerator.new()

var patroll_dir : int = 1

var scale_factor : float = 1

var chasing := false
var alert := false

var size_tween : Tween = null

func _ready():
	$idle_timer.wait_time = rng.randf_range(0.5,1.5)
	idle_stream.set_volume_db(linear_to_db(0.1))
	chase_stream.set_volume_db(linear_to_db(0.1))

func _physics_process(delta):
	$VisionCast.target_position = (global_position.direction_to(rat.position) * vision_distance) / scale_factor
	
	if chasing:
		follow_rat(delta)
	elif not alert:
		patroll(delta)
	
	velocity.y += gravity_acceleration * delta
	move_and_slide()

func follow_rat(delta):
	animated_sprite.play("correr")
	if not can_see_rat() and $focus_timer.is_stopped():
		loose_focus()
	
	var dir = sign(rat.position.x - global_position.x)
	
	animated_sprite.flip_h = (dir == 1)
	velocity.x += dir * acceleration * delta
	velocity.x = clamp(velocity.x, -chase_speed, chase_speed)
	
	if dir != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

func patroll(delta):
	animated_sprite.play("caminar")
	if patroll_dir == 1 and not $RightFloorCast.is_colliding() and is_on_floor():
		animated_sprite.flip_h = false
		patroll_dir = -1
	if patroll_dir == -1 and not $LeftFloorCast.is_colliding() and is_on_floor():
		animated_sprite.flip_h = true
		patroll_dir = 1
	
	for cast : RayCast2D in $LeftWallCasts.get_children():
		if cast.is_colliding():
			animated_sprite.flip_h = true
			patroll_dir = 1
			break
	
	for cast : RayCast2D in $RightWallCasts.get_children():
		if cast.is_colliding():
			animated_sprite.flip_h = false
			patroll_dir = -1
			break
	
	velocity.x += patroll_dir * acceleration * delta
	velocity.x = clamp(velocity.x, -patroll_speed, patroll_speed)
	if patroll_dir != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	# Detección de la rata
	if can_see_rat():
		alert = true
		animated_sprite.play("Alert")
		$surprise_stream.play()
		
		await get_tree().create_timer(.4).timeout
		chasing = true
		var dir = sign(rat.position.x - global_position.x)
		velocity.x = 100 * dir
		alert = false

func loose_focus():
	$focus_timer.start()

func can_see_rat() -> bool:
	if (not $VisionCast.is_colliding()) or (not $VisionCast.get_collider() is Rata):
		return false
	if abs(rat.position.y - global_position.y) > max_height_vision_distance:
		return false
	return true

var scale_time : float = .1

func enlarge():
	scale_factor = 2
	
	start_size_animation()
	
	$ScaleTimer.start()

func reduce():
	scale_factor = .5
	
	start_size_animation()
	
	$ScaleTimer.start()

func start_size_animation():
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", scale_factor * Vector2.ONE, scale_time)

func _on_scale_timer_timeout():
	scale_factor = 1
	start_size_animation()

func _on_hit_box_body_entered(body):
	if body is Rata:
		body.die()

func _on_idle_timer_timeout():
	$idle_timer.wait_time = rng.randf_range(4.5,7.5)
	if not chasing:
		idle_stream.play()

func _on_chase_timer_timeout():
	if chasing:
		chase_stream.play()

func _on_focus_timer_timeout():
	if not can_see_rat():
		$confused_stream.play()
		chasing = false
