extends Node

var rng = RandomNumberGenerator.new()
var level : int = 1
var strokes: int = 0
var holePos: Vector3
var difficulty: String = "hard"
var mode: String = "normal"
var maxStrokes: int

var str = "level %s: %s"
var str2 = "level %s: %s (%s strokes)"

signal updateHole
signal updateObstacles
signal updateInterface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	var temp = str % [level, holePos]
	if mode == "normal":
		maxStrokes = 12
	elif mode == "":
		maxStrokes = 50
	print(temp)
	emit_signal("updateHole")

func nextLevel() -> void:
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	level += 1
	var temp = str2 % [level, holePos, strokes]
	print(temp)
	emit_signal("updateHole")
	match(difficulty):
		'easy':
			emit_signal("updateObstacles", 5 * level)
		'medium':
			emit_signal("updateObstacles", 5 * strokes)
		'hard':
			emit_signal("updateObstacles", 5 * (strokes + level))
		'hardcore':
			emit_signal("updateObstacles", 3 * level)
	if not mode == "":
		strokes = 0
	emit_signal("updateInterface")
	
func stroke() -> void:
	strokes += 1
	emit_signal("updateInterface")
