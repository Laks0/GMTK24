extends Area2D

@export var camera_rect : Polygon2D

var limit_bottom : float
var limit_top    : float
var limit_right  : float
var limit_left   : float

func _ready():
	var points_in_global : Array[Vector2]
	for p in camera_rect.polygon:
		points_in_global.append(camera_rect.to_global(p))
	
	limit_bottom = points_in_global.map(func(p : Vector2): return p.y).max()
	limit_top    = points_in_global.map(func(p : Vector2): return p.y).min()
	limit_left   = points_in_global.map(func(p : Vector2): return p.x).min()
	limit_right  = points_in_global.map(func(p : Vector2): return p.x).max()

func _on_body_entered(body):
	if not body is Rata:
		return
	
	var new_camera := Camera2D.new()
	new_camera.limit_bottom = limit_bottom
	new_camera.limit_top    = limit_top
	new_camera.limit_left   = limit_left
	new_camera.limit_right  = limit_right
	body.switch_cameras(new_camera)
