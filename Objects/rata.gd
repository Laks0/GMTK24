extends CharacterBody2D
class_name Rata

@export var acceleration : float = 300
@export var max_speed : float = 300
@export var friction : float = 20
@export var jump_speed : float = 400

@export var gravity_acceleration : float = 980

func _physics_process(delta):
	var dir : int = 0
	if Input.is_action_pressed("Right"):
		dir = -1
	if Input.is_action_pressed("Left"):
		dir = 1
	
	velocity.x += acceleration * dir * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if sign(velocity.x) != dir:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	velocity.y += gravity_acceleration * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jump_speed
	
	move_and_slide()
