extends Node

var str = "Level: %s\nStrokes: %s"
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("updateInterface", updateInterface)
	updateInterface()

func updateInterface():
	var temp = str % [PlayerVariables.level, PlayerVariables.strokes]
	self.text = temp
