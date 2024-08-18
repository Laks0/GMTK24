extends CharacterBody2D
class_name Rata

@export var acceleration : float = 300
@export var max_speed : float = 300
@export var friction : float = 20
@export var jump_speed : float = 400
@export var wall_jump_speed : float = 200
@export var wall_jump_bounce : float = 500

@export var gravity_acceleration : float = 980

var can_left_wall_jump := true
var can_right_wall_jump := true

var grabbing_funnel : Funnel = null
## Relación entre la dirección del embudo cuando fue agarrado y de la dirección,
## 1 si eran iguales y -1 si eran distintas, se tiene que mantener constante
var funnel_direction_relation : int = 1

func _physics_process(delta):
	var dir : int = 0
	if Input.is_action_pressed("Right"):
		dir = 1
	if Input.is_action_pressed("Left"):
		dir = -1
	
	velocity.x += acceleration * dir * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if sign(velocity.x) != dir:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	velocity.y += gravity_acceleration * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jump_speed
	
	if is_on_floor():
		can_left_wall_jump = true
		can_right_wall_jump = true
	
	if Input.is_action_just_pressed("Jump") and not is_on_floor() and $LeftCast.is_colliding()\
		and can_left_wall_jump:
		velocity.y = -wall_jump_speed
		velocity.x = wall_jump_bounce
		can_left_wall_jump = false
		can_right_wall_jump = true
	
	if Input.is_action_just_pressed("Jump") and not is_on_floor() and $RightCast.is_colliding()\
		and can_right_wall_jump:
		velocity.y = -wall_jump_speed
		velocity.x = wall_jump_bounce
		can_left_wall_jump = true
		can_right_wall_jump = false
	
	move_and_slide()
	
	$GrabCast.target_position = Vector2(10, 0) * dir
	
	if Input.is_action_just_pressed("grab") and $GrabCast.is_colliding() and grabbing_funnel == null:
		attempt_grab()
	
	if grabbing_funnel != null:
		var grab_direction := (1 if dir == 0 else dir)
		grabbing_funnel.scale.x = abs(grabbing_funnel.scale.x) * grab_direction * funnel_direction_relation
		grabbing_funnel.position = global_position + Vector2(16, 0) * grab_direction
		if Input.is_action_just_released("grab"):
			grabbing_funnel.freeze = false
			grabbing_funnel = null

func attempt_grab():
	var body = $GrabCast.get_collider()
	if not body is Funnel:
		return
	body.freeze = true
	grabbing_funnel = body
	var dir = sign($GrabCast.target_position.x)
	if dir == sign(body.scale.x):
		funnel_direction_relation = 1
	else:
		funnel_direction_relation = -1
