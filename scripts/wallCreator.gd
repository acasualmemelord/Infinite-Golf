extends Node

var rng = RandomNumberGenerator.new()
var wall
var walls = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerVariables.connect("updateObstacles", updateObstacles)
	wall = get_parent().get_node("Wall")
	pass # Replace with function body.

func updateObstacles(num) -> void:
	destroyObstacles()
	for n in range(0, num):
		var temp = wall.duplicate()
		temp.position = Vector3(rng.randf_range(-8, 8), 0.5, rng.randf_range(-8, 8))
		temp.rotation = Vector3(0, deg_to_rad(rng.randf_range(0, 360)), 0)
		temp.size = Vector3(rng.randf_range(1, 5), 0.5, 0.4)
		temp.add_to_group("Wall")
		walls.append(temp)
		self.get_parent().add_child(temp)

func destroyObstacles() -> void:
	for n in walls.size():
		walls[n].queue_free()
	walls = []
