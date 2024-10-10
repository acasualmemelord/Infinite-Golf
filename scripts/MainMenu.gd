extends Node

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Difficulties.tscn")

func _on_settings_button_pressed() -> void:
	var settings = load("res://scenes/Settings.tscn").instantiate()
	get_tree().current_scene.add_child(settings)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
