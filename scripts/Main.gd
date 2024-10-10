extends Node

var menu: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu = get_node("PauseMenu")
	menu.hide()

func _input(event) -> void:
	if event.is_action_released("escape"):
		pause(PlayerVariables.paused)
		
func pause(state):
	if state:
		menu.hide()
		Engine.time_scale = 1
		PlayerVariables.paused = false
	else:
		menu.show()
		Engine.time_scale = 0
		PlayerVariables.paused = true

func _on_resume_button_pressed() -> void:
	pause(PlayerVariables.paused)

func _on_settings_button_pressed() -> void:
	var settings = load("res://scenes/Settings.tscn").instantiate()
	get_tree().current_scene.add_child(settings)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
