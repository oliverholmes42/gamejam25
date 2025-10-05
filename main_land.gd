extends Node2D

@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var enemies: Node2D = $Enemies
@onready var timer: Timer = $Timer
@onready var BossSpawner: Marker2D = $BossSpawner

@export var enemy_scene: PackedScene   # drag Enemy.tscn in the inspector
@export var BossScene: PackedScene

signal awardPoints
signal triggerLore
var killcount = 0


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	var spawns = enemy_spawns.get_children()
	if spawns.is_empty():
		return
		
	var marker: Marker2D = spawns.pick_random()
	var enemy = enemy_scene.instantiate()
	enemy.global_position = marker.global_position

	# connect the signal to the player
	var player = get_tree().get_first_node_in_group("player")
	enemy.givePoints.connect(player.add_points)
	enemy.AddKill.connect(addKill)
	enemies.add_child(enemy)
	
func givePoints(points):
	print("points: ", points)
	emit_signal("awardPoints", points)
	
func spawnBoss():
	var boss = BossScene.instantiate()
	add_child(boss)
	boss.global_position = BossSpawner.global_position
	
func addKill():
	killcount +=1
	if killcount >= 50:
		spawnBoss()
		emit_signal("triggerLore", "50-kills")
	elif killcount >= 40:
		emit_signal("triggerLore", "40-kills")
	elif killcount >= 25:
		emit_signal("triggerLore", "25-kills")
	elif killcount >= 10:
		emit_signal("triggerLore", "10-kills")
	
