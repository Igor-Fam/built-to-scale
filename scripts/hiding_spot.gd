extends Area2D

class_name HidingSpot

@export var hidingAnimation: String
@onready var hidingPosition: Vector2 = $HidingPosition.position
@onready var label = $Label

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	label.visible = true

func _on_area_exited(area):
	label.visible = false
