extends Node

var rng = RandomNumberGenerator.new()
var wall
var walls = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerVariables.connect("updateObstacles", updateObstacles)
	wall = get_parent().get_node("Wall")
	updateObstacles(10)

func updateObstacles(num) -> void:
	if not PlayerVariables.difficulty == "hardcore":
		destroyObstacles()
	for n in range(0, num):
		var temp = wall.duplicate()
		var length = rng.randf_range(1, 5)
		var rotation = Vector3(0, deg_to_rad(rng.randf_range(0, 24) * 15), 0)
		
		# randomize wall
		temp.position = Vector3(rng.randf_range(-8, 8), 0.5, rng.randf_range(-8, 8))
		temp.rotation = rotation
		temp.size = Vector3(length, 0.5, 0.4)
		if PlayerVariables.difficulty == "hardcore":
			temp.hits = 3
		elif rng.randf() < PlayerVariables.orangeChance:
			temp.hits = 2
		else:
			temp.hits = 1
		
		# update collision to match
		var newCollision = BoxShape3D.new()
		newCollision.size = temp.size
		temp.get_child(0).get_child(0).set_shape(newCollision)
		
		# add wall to game
		temp.add_to_group("Wall")
		walls.append(temp)
		self.get_parent().get_parent().add_child.call_deferred(temp)

func destroyObstacles() -> void:
	for n in walls.size():
		if !walls[n]:
			continue
		walls[n].queue_free()
	walls = []
