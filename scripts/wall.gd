extends Node

func _on_ready():
	var area2d = $"Area2d"
	area2d.connect("area_entered", _hit_building)

func _hit_building(area): #area is the Area2D of the building
	print("hit")
