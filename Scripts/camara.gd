extends Camera2D
@export var sensitivity:int = 25
@export var speed:float =10

# Called when the node enters the scene tree for the first time.
func _ready():
	position_smoothing_enabled = true
	position_smoothing_speed = 5
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position =  get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	var left_threshold = sensitivity
	var right_threshold = viewport_size.x - sensitivity
	var top_threshold = sensitivity
	var bottom_threshold = viewport_size.y-sensitivity
	
	var near_left_edge = mouse_position.x<left_threshold
	var near_right_edge = mouse_position.x > right_threshold
	var near_top_edge = mouse_position.y < top_threshold
	var near_bottom_edge = mouse_position.y>bottom_threshold
	
	var direction:Vector2 =Vector2(0,0)
	if near_left_edge:
		direction=Vector2(-1,0)
	elif near_right_edge:
		direction=Vector2(1,0)
	elif near_top_edge:
		direction=Vector2(0,-1)
	elif near_bottom_edge:
		direction=Vector2(0,1)
	position +=direction*speed
	
