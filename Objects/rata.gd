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

@export var camera : Camera2D

@onready var jump_audio = $jump_audio
@onready var background_audio = $background_audio

var rng = RandomNumberGenerator.new()
func _ready():
	DeathHandler.load_point(self)
	jump_audio.set_volume_db(linear_to_db(0.1))
	var my_random_number = rng.randf_range(1.0,3.0)

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
		animated_sprite.speed_scale = 1
		
		if jumping:
			#audio_stream_player.
			$continous_loop_rata_audio.stop()
			animated_sprite.play("Jump")
		elif not is_on_floor():
			$continous_loop_rata_audio.stop()
			animated_sprite.play("Falling")
		elif dir == 0:
			$continous_loop_rata_audio.stop()
			animated_sprite.play("idle")
		else:
			animated_sprite.play("caminar")
			if not $continous_loop_rata_audio.playing:
				$continous_loop_rata_audio.play()
		
		if dir == -1:
			animated_sprite.flip_h = true
		if dir == 1:
			animated_sprite.flip_h = false
	
	var trying_to_climb := Input.is_action_pressed("Climb") or ((not is_on_floor()) and Input.is_action_pressed("Jump") and not jumping)
	if trying_to_climb and $BLeftCast.is_colliding() and can_start_climb():
		climbing = true
		climbing_dir = -1
	if trying_to_climb and $BRightCast.is_colliding() and can_start_climb():
		climbing = true
		climbing_dir = 1
	
	if is_on_floor():
		stamina_left = stamina_time
		$ClimbCooldown.stop()
	
	$StaminaBar.visible = climbing
	
	velocity.y = clamp(velocity.y, -600, 600)
	
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
	
	velocity.y += gravity_acceleration * delta * (1 if $ClimbCooldown.is_stopped() else .8)
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jump_speed
		jump_audio.play()
		jumping = true
		
		await get_tree().create_timer(jumping_animation_time).timeout
		jumping = false
	
	if not is_on_floor() and not Input.is_action_pressed("Jump") and $ClimbCooldown.is_stopped():
		velocity.y += gravity_acceleration * delta * 1.3
	if Input.is_action_just_released("Jump") and velocity.y < 0.0:
		velocity.y = 0

func can_start_climb() -> bool:
	if stamina_left <= 0 or climbing:
		return false
	if not $ClimbCooldown.is_stopped():
		return false
	if is_on_floor():
		return false
	return true

func climbing_movement(delta : float):
	stamina_left -= delta
	if stamina_left <= 0:
		stop_climbing()
		return
	
	$StaminaBar.max_value = stamina_time
	$StaminaBar.value = stamina_left
	
	if(stamina_left<=1.26 and not $stamina_audio.playing):
		$stamina_audio.play()
	
	var stamina_percentage_used : float = 1 - (stamina_left/stamina_time)
	animated_sprite.speed_scale =1 + stamina_percentage_used * 1.5
	
	
	
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
		or Input.is_action_just_pressed("Jump")\
		or is_on_floor():
		stop_climbing()
	
	# Si te quedás sin pared
	if climbing_dir == -1 and not $TLeftCast.is_colliding():
		stop_climbing()
		# Si la parte de abajo sigue tocando una pared, saltamos un poco
		if $BLeftCast.is_colliding():
			velocity.y -= 100
	
	if climbing_dir == 1 and not $TRightCast.is_colliding():
		stop_climbing()
		# Si la parte de abajo sigue tocando una pared, saltamos un poco
		if $BRightCast.is_colliding():
			velocity.y -= 100

func stop_climbing():
	climbing = false
	$ClimbCooldown.start()

func _on_queso_detector_area_entered(_area):
	get_parent().get_node("reja").queue_free()

func _on_fake_tile_detector_area_entered(area):
	area.get_parent().get_node("tile").visible = false
	print("wassup")

func switch_cameras(cam : Camera2D):
	var tween := create_tween()
	#tween.tween_property(camera, "position", cam.get_screen_center_position(), .2)
	tween.tween_callback(func ():
		add_child(cam)
		cam.make_current()
		camera.queue_free()
		camera = cam)

func die():
	$die_audio.play()
	get_tree().reload_current_scene()

func _on_background_timer_timeout():
	$background_timer.wait_time = rng.randf_range(15.0,35.0)
	background_audio.play()


func _on_animated_sprite_frame_changed():
	if jumping:
		$continous_loop_rata_audio.stop()
	if climbing:
		$continous_loop_rata_audio.stop()
		if $animated_sprite.frame==2 and $animated_sprite.animation=="caminar":
			$right_steps_rata_audio.play()
		elif $animated_sprite.frame==4 and $animated_sprite.animation=="caminar":
			$left_steps_rata_audio.play()
	
