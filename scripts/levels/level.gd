extends Node2D

class_name Level

@onready var fadeAnimator: AnimationPlayer = $FadeTransition/AnimationPlayer
@onready var fadeColorRect: ColorRect = $FadeTransition/ColorRect
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")
@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var monster: Monster = get_tree().get_first_node_in_group("Monster")

@export var isScreenShaking = false
@export var screenshakeMagnitude: int = 1

var isMonsterKilling: bool = false

func _ready():
	get_tree().paused = true
	fadeAnimator.animation_finished.connect(_on_fade_animation_finished)
	fadeAnimator.play("fade_in")
	player.entered_door.connect(_on_player_entered_door)
	level_ready()

func _process(delta):
	if(isScreenShaking):
		shake_screen()
	
	level_process(delta)

func level_ready():
	pass

func level_process(delta):
	pass

func center_fade_rect():
	var size = fadeColorRect.get_rect().size
	var newPosition = camera.global_position - (size/2)
	fadeColorRect.global_position = newPosition

func pause_or_resume():
	get_tree().paused = !get_tree().paused

func toggle_player_movement():
	if(player.state == player.states.WAIT):
		player.state = player.states.MOVE
	else:
		player.state = player.states.WAIT

func _on_fade_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		GameController.load_next_level()

func _on_player_entered_door():
	fadeAnimator.play("fade_out")

func shake_screen():
	print(screenshakeMagnitude)
	var rng = RandomNumberGenerator.new()
	camera.position = Vector2(rng.randf_range(-screenshakeMagnitude, screenshakeMagnitude), rng.randf_range(-screenshakeMagnitude, screenshakeMagnitude))
