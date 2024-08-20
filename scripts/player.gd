extends CharacterBody2D

class_name Player

enum states{
	MOVE,
	HIDE,
	WAIT,
	NONE
}

signal slept

const SPEED = 70.0
const JUMP_VELOCITY = -180.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state: states
var isHidden: bool = false
var selectedObject: Area2D
var positionBeforeHiding: Vector2

@onready var sprite = $AnimatedSprite2D
@onready var interactionRange = $InteractionRange
@onready var camera = get_tree().get_first_node_in_group("Camera")

func _physics_process(delta):
	match state:
		states.MOVE:
			move_state(delta)
		states.HIDE:
			hide_state(delta)
		states.WAIT:
			wait_state(delta)

func move_state(delta):
	get_target()
	
	if Input.is_action_just_pressed("ui_interact") and is_on_floor():
		if(selectedObject is HidingSpot):
			state = states.HIDE
			positionBeforeHiding = global_position
			interactionRange.monitorable = false
			interactionRange.monitoring = false
			return
		
		if(selectedObject is Door):
			GameController.load_next_level()
			return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction == -1
		interactionRange.position.x = 8 * direction
		interactionRange.rotation_degrees = 0 if direction == 1 else 180
		sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x == 0 and velocity.y == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")

	
	move_and_slide()

func wait_state(delta):
	sprite.play("idle")
	velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func hide_state(delta):
	var globalHidingPosition = selectedObject.hidingPosition + selectedObject.global_position
	var dir = (globalHidingPosition - global_position)
	
	if(dir.length() <= 10):
		sprite.flip_h = selectedObject is Bed
		isHidden = true
		velocity = Vector2.ZERO
		sprite.animation = selectedObject.hidingAnimation
		global_position = globalHidingPosition
		
		if(selectedObject is Bed):
			slept.emit()
			state = states.NONE
		
		if Input.is_action_just_pressed("ui_interact"):
			isHidden = false
			global_position.y = positionBeforeHiding.y
			state = states.MOVE
			sprite.play("idle")
			interactionRange.monitorable = true
			interactionRange.monitoring = true
			return
	else:
		sprite.play("walk")
		
		if(dir.x < 0):
			sprite.flip_h = true
		else: 
			sprite.flip_h = false
		
		velocity = dir.normalized() * SPEED
		
		move_and_slide()

func get_target():
	var objsInRange = interactionRange.get_overlapping_areas()
	if(len(objsInRange) == 0):
		selectedObject = null
	
	var nearestDistance = 99999999
	for obj in objsInRange:
		var distance = interactionRange.global_position.distance_squared_to(obj.global_position)
		if(distance < nearestDistance):
			nearestDistance = distance
			selectedObject = obj
