extends Level

@onready var monsterFace = $Player/Monster
@onready var animator = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func level_ready():
	player.slept.connect(_on_player_slept)

func _on_player_slept():
	animator.play("end")

func shake_screen():
	var rng = RandomNumberGenerator.new()
	camera.position = Vector2(rng.randf_range(-4, 4), rng.randf_range(-4, 4))

func get_credits():
	GameController.load_next_level()
