extends Control

@onready var animator = $AnimationPlayer

func _ready():
	animator.play("fade_in")

func _on_button_pressed():
	animator.play("fade_out")

func load_level():
	GameController.reload_level()
