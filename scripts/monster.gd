extends Node2D

class_name Monster

const KILL_SPEED = 10

signal saw_player

@onready var raycast: RayCast2D = $RayCast2D
@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var light = $PointLight2D
@onready var killTimer = $KillTimer

var killing = false

@export var enabled = false

func _ready():
	raycast.collide_with_areas = true

func _process(delta):
	light.enabled = light.global_position.y < player.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_rotation = 0
	
	raycast.target_position = to_local(player.global_position)
	raycast.target_position.y += 30
	
	if(!enabled): 
		return
	
	if(killTimer.time_left == 0):
		check_if_seeing_player(true)
	
	if(killing):
		var rng = RandomNumberGenerator.new()
		sprite.position = Vector2(rng.randf_range(-3, 3), rng.randf_range(-3, 3))

func check_if_seeing_player(first: bool = false):
	var seenObject = raycast.get_collider()
	if(seenObject is Player && !player.isHidden):
		if(first):
			killTimer.start()
			return
		kill()

func _on_kill_timer_timeout():
	check_if_seeing_player()

func game_over():
	get_tree().change_scene_to_file("res://nodes/game_over_screen.tscn")

func kill():
	print("jajaja")
	return
	saw_player.emit()
	animator.play("kill")
	sprite.play("killing")
	killing = true
	player.process_mode = Node.PROCESS_MODE_DISABLED

