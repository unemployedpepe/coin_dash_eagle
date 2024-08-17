extends Area2D
@export var speed = 300
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)
signal pickup # emit when touch a coin
signal hurt #emit when touch an obstacle 




func _process(delta):
	velocity  = Vector2(Input.get_axis("left", "right"), Input.get_axis("up","down"))
	position += velocity * speed * delta 
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	
	if velocity.length() > 0 :
		$AnimatedSprite2D.play("run")
	else: 
		$AnimatedSprite2D.play("idle")
	if velocity.x != 0 : 
		$AnimatedSprite2D.flip_h = velocity.x < 0 
		
func start_game():
	set_process(true)
	position = screensize/1.8
	$AnimatedSprite2D.play("idle")
	
func die():
	$AnimatedSprite2D.play("hurt")
	set_process(false)
		


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coins")
	if area.is_in_group("obstacle"):
		hurt.emit()
		die()
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerups")


func _on_body_entered(_body):
	hurt.emit()
	die()	
