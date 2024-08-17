extends CharacterBody2D
const SPEED = 1000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var paso_por_embudo:bool =false
var tiempo_embudo:float = 0.1
func _ready():
	velocity.x=1000



func _physics_process(delta):
	tiempo_embudo -=delta
	if tiempo_embudo <= 0.0:
		tiempo_embudo = 0.25
		paso_por_embudo = false
	var x=1
	velocity.y+=100
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall():
		velocity.x*=-1
	move_and_slide()
	velocity.x *=x


func _on_big_embudo_detector_area_entered(area):
	if !paso_por_embudo:
		scale*=2
		reset_embudo()

func _on_small_embudo_detector_area_entered(area):
	if !paso_por_embudo:
		scale *=0.5
		reset_embudo()


func reset_embudo():
	paso_por_embudo=true
	tiempo_embudo=0.1
