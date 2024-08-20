extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var monsterFace = $Player/Monster
@onready var animator = $AnimationPlayer
@onready var camera = $Player/Camera2D

@export var isScreenShaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.slept.connect(_on_player_slept)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isScreenShaking):
		shake_screen()

func _on_player_slept():
	animator.play("end")

func shake_screen():
	var rng = RandomNumberGenerator.new()
	camera.position = Vector2(rng.randf_range(-4, 4), rng.randf_range(-4, 4))

func get_credits():
	GameController.load_next_level()
