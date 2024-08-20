extends Area2D
class_name Food

@export_range(0,7) var num : int = 0

var got := false

var hover_tween : Tween

func _ready():
	if DeathHandler.is_food_gotten(num):
		queue_free()
	
	$Sprite2D.region_rect.position.x = 16 * (num % 4)
	$Sprite2D.region_rect.position.y = 16 * floor(num/4)
	
	hover_tween = create_tween().set_loops()
	hover_tween.set_ease(Tween.EASE_IN_OUT)
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.tween_property($Sprite2D, "position:y", -10, .7)
	hover_tween.tween_property($Sprite2D, "position:y", 10, .7)

func _on_body_entered(body):
	if body is Rata and not got:
		# Se agarró la comida
		got = true
		var tween := create_tween()
		hover_tween.kill()
		tween.tween_property($Sprite2D, "scale", Vector2.ZERO, .2)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_BACK)
		tween.tween_callback(DeathHandler.get_food.bind(num))
		
		tween.tween_callback(func(): $Label.text = "%s/8" % DeathHandler.foods_obtained.size())
		tween.tween_property($Label, "modulate:a", 1, .2)
		tween.tween_interval(.6)
		tween.tween_property($Label, "modulate:a", 0, .2)
		
		tween.tween_callback(queue_free)
