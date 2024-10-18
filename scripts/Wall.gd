extends Node

var hits: int
var red = preload("res://assets/red.tres")
var pink = preload("res://assets/pink.tres")
var orange = preload("res://assets/orange.tres")
var purple = preload("res://assets/purple.tres")

var arr = [red, orange, purple]
var colorblindArr = [pink, orange, purple]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateTexture()
	
func updateTexture() -> void:
	self.material = arr[hits - 1] if !PlayerVariables.colorblind else colorblindArr[hits - 1]

func hit() -> void:
	hits -= 1
	if hits == 0:
		PlayerVariables.wallsDestroyed += 1
		allWallsDestroyed()
		self.queue_free()
	else:
		updateTexture()

func allWallsDestroyed() -> void:
	if PlayerVariables.wallsDestroyed == PlayerVariables.numWalls:
		PlayerVariables.score += 20
		PlayerVariables.emit_signal("updateInterface")
