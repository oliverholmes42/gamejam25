extends Node2D

@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var enemies: Node2D = $Enemies
@onready var timer: Timer = $Timer

@export var enemy_scene: PackedScene   # drag Enemy.tscn in the inspector

signal awardPoints


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	# pick a random spawn point
	var spawns = enemy_spawns.get_children()
	if spawns.is_empty():
		return

	var marker: Marker2D = spawns.pick_random()

	# spawn an enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = marker.global_position
	enemy.givePoints.connect(givePoints)
	# add it under the Enemies container
	enemies.add_child(enemy)
	
func givePoints(points):
	print("points: ", points)
	emit_signal("awardPoints", points)
