extends Node

var rng = RandomNumberGenerator.new()

var difficulty: String = "medium"
var mode: String = "normal"

var level : int = 1
var strokes: int = 0

var holePos: Vector3
var numWalls: int
var wallsDestroyed: int = 0
var orangeChance: float = 0

var maxStrokes: int
var score: int = 0
var highScore: int = 0

var paused: bool = false

var prevMaster = 1
var prevMusic = 0.5
var prevSFX = 0.5
var colorblind: bool = false

var debugStr = "%s difficulty, %s mode\nlevel %s: %s"
var debugStr2 = "level %s: %s (%s strokes)"

@warning_ignore("unused_signal")
signal updateHole
@warning_ignore("unused_signal")
signal updateObstacles
@warning_ignore("unused_signal")
signal updateInterface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	
func start() -> void:
	level = 1
	strokes = 0
	score = 0
	wallsDestroyed = 0
	difficulty = "medium"
	mode = "normal"
	
func play() -> void:
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	var temp = debugStr % [difficulty, mode, level, holePos]
	if mode == "normal":
		maxStrokes = 12
	elif mode == "maxstrokes":
		maxStrokes = 50
	emit_signal("updateHole")
	print(temp)

func nextLevel() -> void:
	# calculate score
	var levelScore = 10
	if strokes == 1:
		levelScore += 30
	levelScore += (12 - strokes) * 10
	score += levelScore
	
	var temp = debugStr2 % [level, holePos, strokes]
	print(temp)
	
	if not mode == "maxstrokes":
		strokes = 0
	level += 1
	wallsDestroyed = 0
	emit_signal("updateInterface")
	
	# update level
	holePos = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))
	emit_signal("updateHole")
	orangeChance += 0.01
	match(difficulty):
		'easy':
			numWalls = 5 * strokes
		'medium':
			numWalls = 5 * level
		'hard':
			numWalls = 5 * (strokes + level)
		'hardcore':
			numWalls = 5
	emit_signal("updateObstacles", numWalls)
	
func lose() -> void:
	if score > highScore:
		highScore = score
	var gameover = load("res://scenes/GameOver.tscn").instantiate()
	get_tree().current_scene.add_child(gameover)
	gameover.transition()

func stroke() -> void:
	strokes += 1
	emit_signal("updateInterface")
