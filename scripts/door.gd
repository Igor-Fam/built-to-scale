extends Area2D

class_name Door

@export var sound: String

@onready var label = $Label

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	label.visible = true

func _on_area_exited(area):
	label.visible = false
