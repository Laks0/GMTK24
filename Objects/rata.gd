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
@onready var animated_sprite = $animated_sprite

@export var gravity_acceleration : float = 980

## La dirección en la que te estás moviendo
var dir : int = 0
var grab_direction : int

@export var stamina_time : float = 3
var stamina_left := stamina_time

@export var jumping_animation_time : float = .2
var jumping := false

func _physics_process(delta):
	############
	# Movimiento
	############
	dir = 0
	
	if climbing:
		climbing_movement(delta)
	else:
		regular_movement(delta)
		animated_sprite.rotation = 0
		animated_sprite.flip_v = false
		
		if jumping:
			animated_sprite.play("Jump")
		elif not is_on_floor():
			animated_sprite.play("Falling")
		elif dir == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("caminar")
		
		if dir == -1:
			animated_sprite.flip_h = true
		if dir == 1:
			animated_sprite.flip_h = false
	
	
	if Input.is_action_pressed("Climb") and $BLeftCast.is_colliding() and can_start_climb():
		climbing = true
		climbing_dir = -1
	if Input.is_action_pressed("Climb") and $BRightCast.is_colliding() and can_start_climb():
		climbing = true
		climbing_dir = 1
	
	if is_on_floor():
		stamina_left = stamina_time
	
	move_and_slide()

func regular_movement(delta : float):
	#DUDA: no se si nestear el input asi esta bien
	if Input.is_action_pressed("Right"):
		dir = 1
	elif Input.is_action_pressed("Left"):
		dir = -1
	
	velocity.x += acceleration * dir * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if sign(velocity.x) != dir:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	velocity.y += gravity_acceleration * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jump_speed
		jumping = true
		
		await get_tree().create_timer(jumping_animation_time).timeout
		jumping = false

func can_start_climb() -> bool:
	if stamina_left <= 0 or climbing:
		return false
	return true

func climbing_movement(delta : float):
	stamina_left -= delta
	if stamina_left <= 0:
		climbing = false
		return
	
	var movement_dir : int = 0
	if Input.is_action_pressed("Up"):
		movement_dir = -1
	if Input.is_action_pressed("Down"):
		movement_dir = 1
	
	animated_sprite.rotation = -PI/2
	if movement_dir == 0:
		animated_sprite.stop()
	elif movement_dir == -1:
		animated_sprite.play("caminar")
		animated_sprite.flip_h = false
	elif movement_dir == 1:
		animated_sprite.play("caminar")
		animated_sprite.flip_h = true
	
	animated_sprite.flip_v = climbing_dir == -1
	
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


func _on_queso_detector_area_entered(area):
	get_parent().get_node("reja").queue_free()
