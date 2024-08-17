extends CharacterBody2D

@export var  SPEED = 500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_position 
var target_position 
@onready var player = get_parent().get_node("rata")

func _physics_process(delta):
	velocity.y +=5
	var x=1
	velocity.y+=100
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall():
		velocity.x*=-1
	move_and_slide()
	velocity.x *=x
