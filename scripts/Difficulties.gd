extends Node

var difficulties = ["easy", "medium", "hard", "hardcore"]
var difficultyDesc = 0
var pickedDiff
var difficultyDescs = ["The easiest gamemode. The amount of walls increases solely on the amount of strokes you made on the last level.",
					   "The amount of walls increases solely on the level.",
					   "The amount of walls inceases based both on the level and the amount of strokes you made on the last level.",
					   "The hardest gamemode. The amount of walls inceases by a constant value, but they take 3 hits to destroy."]
var modes = ["arcade", "normal", "maxstrokes"]
var modeDesc = 0
var pickedMode
var modeDescs = ["The casual setting. Play golf at your own pace.",
				 "You must get the ball into the hole within 12 strokes or less.",
				 "You only get 50 strokes. See how many levels you can clear!"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficultyDesc = self.get_node("TextureRect/VBoxContainer/DifficultyDesc")
	modeDesc = self.get_node("TextureRect/VBoxContainer2/ModeDesc")
	var defaultD = self.get_node("TextureRect/VBoxContainer/DifficultyButton")
	var defaultM = self.get_node("TextureRect/VBoxContainer2/ModeButton")
	defaultD.selected = 1
	defaultM.selected = 1
	difficultyDesc.text = difficultyDescs[1]
	modeDesc.text = modeDescs[1]

func _on_difficulty_button_item_selected(index: int) -> void:
	pickedDiff = index
	difficultyDesc.text = difficultyDescs[index]

func _on_mode_button_item_selected(index: int) -> void:
	pickedMode = index
	modeDesc.text = modeDescs[index]

func _on_play_button_pressed() -> void:
	if pickedDiff:
		PlayerVariables.difficulty = difficulties[pickedDiff]
	if pickedMode:
		PlayerVariables.mode = modes[pickedMode]
	PlayerVariables.play()
	get_tree().change_scene_to_file("res://scenes/GolfCourse.tscn")
