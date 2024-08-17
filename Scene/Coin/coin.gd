extends Area2D
var screensize = Vector2.ZERO 

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 0.5, 0.2)
	tw.tween_property(self, "modulate:a", 0.0, 0.2)
	await tw.finished
	queue_free()

func _ready():
	$Timer.start(randf_range(3, 5))

func _on_timer_timeout():
	$AnimatedSprite2D.frame = 0 
	$AnimatedSprite2D.play()


func _on_area_entered(area):
	if area.is_in_group("obstacle"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
