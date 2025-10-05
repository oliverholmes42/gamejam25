extends Node2D

var player
var hud

@onready var active_world: Node2D = $ActiveWorld
@onready var loreManager: CanvasLayer = $LoreManager

signal toTitle

@export var pauseScreen: PackedScene
var pause_instance: CanvasLayer = null
var pause_open := false  

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


func _ready() -> void:
	player = $PlayerCharacter
	hud = $HUD
	player.health_changed.connect(hud.applyHealth)
	player.died.connect(handleDeath)
	player.applyPoints.connect(hud.applyPoints)
	
	load_world("res://main_land.tscn")
	
	
func load_world(path: String) -> void:
	
	active_world.free_children()


	var world_scene: PackedScene = load(path)
	if world_scene == null:
		push_error("Could not load world: %s" % path)
		return
	
	var world_instance: Node2D = world_scene.instantiate()
		
	if world_instance.has_signal("leaveUnderworld"):
		world_instance.leaveUnderworld.connect(loadOverWorld)
		
	if world_instance.has_signal("triggerLore"):
		world_instance.triggerLore.connect(loreManager.render)

	active_world.add_child(world_instance)
	
	var spawn_marker: Marker2D = world_instance.get_node("Spawn") as Marker2D
	if spawn_marker:
		player.global_position = spawn_marker.global_position



func handleDeath():
	load_world("res://under_world.tscn")
	save_player_data()
	if(player.deaths == 1):
		loreManager.render("first death")

func loadOverWorld():
	load_world("res://main_land.tscn")
	player.heal()
	save_player_data()
	
func apply_player_data(data: Dictionary):
	if data.is_empty():
		return
	player.max_health = data.get("max_health", player.max_health)
	player.speed = data.get("speed", player.speed)
	player.deaths = data.get("deaths", player.deaths)
	var score = data.get("score", player.score)
	player.add_points(score)
	if "attack" in data:
		player.swordSwing.attack = data["attack"]

func save_player_data():
	SaveManager.save_player_data(player)
