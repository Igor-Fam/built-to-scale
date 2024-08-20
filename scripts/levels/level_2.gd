extends Level

@onready var goal = $Goal
@onready var eyes = $Eyes

func level_ready():
	goal.body_entered.connect(_on_goal_body_entered)

func _on_goal_body_entered(body):
	fadeAnimator.play("fade_out")
	eyes.play("open")
