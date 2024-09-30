extends Node

var rng = RandomNumberGenerator.new()
var wall
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerVariables.connect("updateObstacles", updateObstacles)
	wall = get_parent().get_node("Wall")
	pass # Replace with function body.

func updateObstacles() -> void:
	var walls = []
	for n in range(0, 5):
		var temp = wall.duplicate()
		temp.position = Vector3(rng.randf_range(-8, 8), 0.5, rng.randf_range(-8, 8))
		temp.rotation = Vector3(0, deg_to_rad(rng.randf_range(0, 360)), 0)
		walls.append(temp)
		self.get_parent().add_child(temp)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
