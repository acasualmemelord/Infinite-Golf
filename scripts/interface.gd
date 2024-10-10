extends Node

var Str = "Level: %s\nStrokes: %s\nScore: %s\nHigh Score: %s"
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("updateInterface", updateInterface)
	updateInterface()

func updateInterface():
	var temp = Str % [PlayerVariables.level, PlayerVariables.strokes, PlayerVariables.score, PlayerVariables.highScore]
	self.text = temp
