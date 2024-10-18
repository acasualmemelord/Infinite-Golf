extends Node
				
var master = AudioServer.get_bus_index("Master")
var music = AudioServer.get_bus_index("Music")
var sfx = AudioServer.get_bus_index("SFX")

var MasterSlider
var MusicSlider
var SFXSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MasterSlider = self.get_node("Field/HBoxContainer/MasterSlider")
	MusicSlider = self.get_node("Field/HBoxContainer/MusicSlider")
	SFXSlider = self.get_node("Field/HBoxContainer/SFXSlider")
	MasterSlider.value = PlayerVariables.prevMaster
	MusicSlider.value = PlayerVariables.prevMusic
	SFXSlider.value = PlayerVariables.prevSFX
	AudioServer.set_bus_volume_db(master, linear_to_db(PlayerVariables.prevMaster))
	AudioServer.set_bus_volume_db(music, linear_to_db(PlayerVariables.prevMusic))
	AudioServer.set_bus_volume_db(sfx, linear_to_db(PlayerVariables.prevSFX))

func _on_save_button_pressed() -> void:
	PlayerVariables.prevMaster = db_to_linear(AudioServer.get_bus_volume_db(master))
	PlayerVariables.prevMusic = db_to_linear(AudioServer.get_bus_volume_db(music))
	PlayerVariables.prevSFX = db_to_linear(AudioServer.get_bus_volume_db(sfx))
	self.get_parent().remove_child(self)

func _on_cancel_button_pressed() -> void:
	self.get_parent().remove_child(self)

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx, linear_to_db(value))

func _on_colorblind_button_toggled(toggled_on: bool) -> void:
	PlayerVariables.colorblind = toggled_on
