extends Node2D

var player
var hud
var Tpoints = 0
@onready var active_world: Node2D = $ActiveWorld

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
	print("u ded")
	load_world("res://under_world.tscn")

func loadOverWorld():
	load_world("res://main_land.tscn")
	player.heal()
