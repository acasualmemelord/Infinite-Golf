extends Node

var rng = RandomNumberGenerator.new()
var level : int = 1
var strokes: int = 0
var holePos: Vector3
#var updateObstacles: bool = false;

var str = "level %s: %s"
var str2 = "level %s: %s (%s strokes)"

signal updateHole
signal updateObstacles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	var temp = str % [level, holePos]
	print(temp)
	emit_signal("updateHole")

func nextLevel() -> void:
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	level += 1
	var temp = str2 % [level, holePos, strokes]
	print(temp)
	strokes = 0
	emit_signal("updateHole")
	emit_signal("updateObstacles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
