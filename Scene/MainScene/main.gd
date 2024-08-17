extends Node2D
@export var coin_scene : PackedScene
@export var powerups_scene : PackedScene
@export var eagle_scene :PackedScene
@export var playtime = 30
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO 
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	$MainOst.play()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func new_game():
	playing = true 
	level = 1
	score = 0 
	time_left = playtime
	$EaglesPath/EaglesSpawnLocation/Eagle.show() 
	$Player.start_game()
	$Player.show()
	spawn_coins()
	$GameTimer.start()
	
	

	
func spawn_coins():
	for i in level +4 : 	
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize 
		c.position = Vector2(randi_range(37, 438), randi_range(34, 694))
		
func _process(_delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0 :
		level += 1 
		time_left += 5 
		spawn_coins()
		$PowerUpTimer.wait_time = randf_range(2, 10)
		$PowerUpTimer.start()
		

		
		
		
func game_over() :
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	$HeadsUpDisplay.show_game_over()
	$Player.die()
	$MainOst.stop()
	
func _on_game_timer_timeout():
	time_left -= 1 
	$HeadsUpDisplay.update_timer(time_left)
	if time_left < 0 :
		game_over()
	
func _on_player_hurt():
	game_over()
	$EndSound.play()

func _on_player_pickup(type):
	match type:
		"coins":
			score += 1 
			$HeadsUpDisplay.update_score(score)
			$CoinSound.play()
		"powerups":
			$PowerUpSound.play()
			time_left += 2 
			$HeadsUpDisplay.update_timer(time_left)

func _on_heads_up_display_start():
	new_game()


func _on_power_up_timer_timeout():
	var p = powerups_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


	
	
	
	
	
