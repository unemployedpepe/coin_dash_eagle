extends Path2D
@onready var path_follow = $EaglesSpawnLocation
@export var eagle_scene : PackedScene
var speed = 200

func _process(delta) -> void :
	var e = eagle_scene.instantiate()
	path_follow.progress += speed *delta 
	


