extends CharacterBody2D
class_name Rata

@export var acceleration : float = 300
@export var max_speed : float = 300
@export var friction : float = 20
@export var jump_speed : float = 400

@export var climb_acceleration : float = 800
@export var max_climb_speed : float = 100
var climbing := false
var climbing_dir := 0

@export var gravity_acceleration : float = 980

var grabbing_funnel : Funnel = null
## Relación entre la dirección del embudo cuando fue agarrado y de la dirección,
## 1 si eran iguales y -1 si eran distintas, se tiene que mantener constante
var funnel_direction_relation : int = 1

## La dirección en la que te estás moviendo
var dir : int = 0

func _physics_process(delta):
	############
	# Movimiento
	############
	dir = 0
	
	if climbing:
		climbing_movement(delta)
	else:
		regular_movement(delta)
	
	if Input.is_action_just_pressed("Up") and $BLeftCast.is_colliding() and not climbing:
		climbing = true
		climbing_dir = -1
	if Input.is_action_just_pressed("Up") and $BRightCast.is_colliding() and not climbing:
		climbing = true
		climbing_dir = 1
	
	move_and_slide()
	
	###################
	# Agarrar el embudo
	###################
	$GrabCast.target_position = Vector2(10, 0) * dir
	
	if Input.is_action_just_pressed("grab") and $GrabCast.is_colliding() and grabbing_funnel == null:
		attempt_grab()
	
	if grabbing_funnel != null:
		var grab_direction := (1 if dir == 0 else dir)
		grabbing_funnel.scale.x = abs(grabbing_funnel.scale.x) * grab_direction * funnel_direction_relation
		grabbing_funnel.position = global_position + Vector2(20, 0) * grab_direction
		if Input.is_action_just_released("grab"):
			grabbing_funnel.freeze = false
			grabbing_funnel = null

func attempt_grab():
	var body = $GrabCast.get_collider()
	if not body is Funnel:
		return
	body.freeze = true
	grabbing_funnel = body
	if dir == sign(body.scale.x):
		funnel_direction_relation = 1
	else:
		funnel_direction_relation = -1

func regular_movement(delta : float):
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

func climbing_movement(delta : float):
	var movement_dir : int = 0
	if Input.is_action_pressed("Up"):
		movement_dir = -1
	if Input.is_action_pressed("Down"):
		movement_dir = 1
	
	velocity.y += climb_acceleration * delta * movement_dir
	
	velocity.y = clamp(velocity.y, -max_climb_speed, max_climb_speed)
	if movement_dir != sign(velocity.y):
		velocity.y = lerp(velocity.y, 0.0, friction * delta)
	
	# Botones para dejar de trepar
	if Input.is_action_just_pressed("Right") and climbing_dir == -1\
		or Input.is_action_just_pressed("Left") and climbing_dir == 1\
		or Input.is_action_just_pressed("Jump"):
		climbing = false
	
	# Si te quedás sin pared
	if climbing_dir == -1 and not $TLeftCast.is_colliding():
		climbing = false
		# Si la parte de abajo sigue tocando una pared, saltamos un poco
		if $BLeftCast.is_colliding():
			velocity.y -= 100
	
	if climbing_dir == 1 and not $TRightCast.is_colliding():
		climbing = false
		# Si la parte de abajo sigue tocando una pared, saltamos un poco
		if $BRightCast.is_colliding():
			velocity.y -= 100
