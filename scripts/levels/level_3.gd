extends Level

@onready var monsterHolder = $MonsterHolder
@onready var monsterAnimator = $MonsterHolder/MonsterAnimator
@onready var monsterTrigger = $MonsterTrigger
@onready var monsterHand = $MonsterHand
@onready var monsterHandAnimator = $MonsterHand/MonsterHandAnimator
@onready var monsterHandTrigger = $MonsterHandTrigger
@onready var goalDoor = $GoalDoor

func level_ready():
	monster.saw_player.connect(_on_monster_saw_player)

func _physics_process(delta):
	var monsterMovingSameDirection = (monsterHolder.global_position.x < player.global_position.x) == (monsterAnimator.current_animation_position > 8)
	if(monsterAnimator.current_animation == "search" && monsterMovingSameDirection || player.velocity.x == 0):
		monsterHolder.global_position.x = lerp(monsterHolder.global_position.x, player.global_position.x, 0.03)
	
	if(isMonsterKilling):
		monsterAnimator.play("kill")
		monster.global_position.x = move_toward(monster.global_position.x, player.global_position.x, monster.KILL_SPEED)
		monster.global_position.y = move_toward(monster.global_position.y, 0, monster.KILL_SPEED)

func _on_monster_trigger_body_entered(body):
	monsterAnimator.play("spawn")
	monsterTrigger.queue_free()

func _on_monster_animation_finished(anim_name):
	if(anim_name == "spawn"):
		monsterAnimator.play("search")

func _on_monster_saw_player():
	isMonsterKilling = true
	monsterAnimator.play("kill")


func _on_monster_hand_trigger_body_entered(body):
	monsterHandAnimator.play("slam")
	goalDoor.visible = true
	goalDoor.monitoring = false
	goalDoor.monitorable = false
	monsterHandTrigger.queue_free()

func _on_monster_hand_body_entered(body):
	monster.kill()
