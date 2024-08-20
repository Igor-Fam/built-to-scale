extends Node

var currentLevel: int = 1

func load_next_level():
	currentLevel += 1
	get_tree().change_scene_to_file("res://nodes/levels/level_" + str(currentLevel) + ".tscn")

func reload_level():
	get_tree().change_scene_to_file("res://nodes/levels/level_" + str(currentLevel) + ".tscn")
