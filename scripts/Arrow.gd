extends Node
var ball
var ball_position: Vector3
var hole_position: Vector3
var arrow: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = get_parent()
	hole_position = PlayerVariables.holePos
	arrow = self
	PlayerVariables.connect("updateHole", updateHole)

func updateHole() -> void:
	hole_position = PlayerVariables.holePos

func _physics_process(_delta: float) -> void:
	ball_position = ball.global_transform.origin

	var direction = hole_position - ball_position
	direction.y = 0

	arrow.look_at(ball_position + direction, Vector3.UP)

	arrow.global_transform.origin = ball_position + Vector3(0, 0, 0)
