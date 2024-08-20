extends AnimatedSprite2D

func _ready():
	get_parent().open.connect(func():
		create_tween().tween_property(self, "modulate:a", .7, .3)
		play("Stream")
	)
	
	get_parent().close.connect(func():
		create_tween().tween_property(self, "modulate:a", 0, .3)
	)
