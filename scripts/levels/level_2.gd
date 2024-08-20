extends Level

@onready var goal = $Goal

func level_ready():
	goal.body_entered.connect(_on_goal_body_entered)

func _on_goal_body_entered(body):
	animator.play("fade_out")
