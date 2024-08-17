extends CharacterBody2D
const SPEED = 300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x=300



func _physics_process(delta):
	var x=1
	velocity.y+=100
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall():
		velocity.x*=-1
	move_and_slide()
	velocity.x *=x



func _on_embudo_detector_area_entered(area):
	var parent = area.get_parent()
	var punta_embudo = parent.get_node("punta_embudo")
	var distancia = position.distance_to(punta_embudo.position)
	print(distancia)
	if distancia<=420:
		print("A")
		scale *=1.5
		return
	else:
		print("B")
		scale *=0.9
		return
