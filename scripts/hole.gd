extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerVariables.connect("updateHole", updateHole)
	self.position = PlayerVariables.holePos
	pass # Replace with function body.

func updateHole() -> void:
	self.position = PlayerVariables.holePos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
