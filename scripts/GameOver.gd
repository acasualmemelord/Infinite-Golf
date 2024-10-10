extends Node

var text = "[center]Your score was: %s[/center]"
var score

func _ready():
	score = get_node("Score")
	text = text % [PlayerVariables.score]
	score.text = text
	pass
	
func transition():
	$AnimationPlayer.play("fade_in")

func _on_restart_button_pressed() -> void:
	PlayerVariables.start()
	get_tree().change_scene_to_file("res://scenes/Difficulties.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
