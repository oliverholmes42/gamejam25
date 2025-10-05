extends Node2D

var player
var hud
#var Tpoints = 0
@onready var active_world: Node2D = $ActiveWorld

signal toTitle

@export var pauseScreen: PackedScene
var pause_instance: CanvasLayer = null
var pause_open := false  # track whether the menu is open


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if not pause_open:
			_show_pause_menu()
		else:
			_hide_pause_menu()


func _show_pause_menu():
	pause_instance = pauseScreen.instantiate()
	add_child(pause_instance)
	pause_instance.goToTitleScreen.connect(gotoTitle)
	pause_open = true

func gotoTitle():
	emit_signal("toTitle")

func _hide_pause_menu():
	if pause_instance:
		pause_instance.queue_free()
		pause_instance = null
	pause_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $PlayerCharacter
	hud = $HUD
	player.health_changed.connect(hud.applyHealth)
	player.died.connect(handleDeath)
	player.applyPoints.connect(hud.applyPoints)
	
	load_world("res://main_land.tscn")
	
	
func load_world(path: String) -> void:
	# Clear old world (if any)
	active_world.free_children()

	# Load and instance the new world
	var world_scene: PackedScene = load(path)
	if world_scene == null:
		push_error("Could not load world: %s" % path)
		return
	
	var world_instance: Node2D = world_scene.instantiate()
		
	if world_instance.has_signal("leaveUnderworld"):
		world_instance.leaveUnderworld.connect(loadOverWorld)

	active_world.add_child(world_instance)
	
	var spawn_marker: Marker2D = world_instance.get_node("Spawn") as Marker2D
	if spawn_marker:
		player.global_position = spawn_marker.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.

func handleDeath():
	load_world("res://under_world.tscn")
	save_player_data()

func loadOverWorld():
	load_world("res://main_land.tscn")
	player.heal()
	save_player_data()
	
func apply_player_data(data: Dictionary):
	if data.is_empty():
		return
	player.max_health = data.get("max_health", player.max_health)
	player.speed = data.get("speed", player.speed)
	var score = data.get("score", player.score)
	player.add_points(score)
	if "attack" in data:
		player.swordSwing.attack = data["attack"]

func save_player_data():
	SaveManager.save_player_data(player)
