extends Node2D

@export var title_screen_scene: PackedScene
@export var game_scene: PackedScene

var title_screen: Control = null
var game_instance: Node = null


func _ready() -> void:
	# Start by loading the title screen
	_load_title_screen()

func _load_title_screen() -> void:
	for child in get_children():
		child.queue_free()

	title_screen = title_screen_scene.instantiate()
	add_child(title_screen)

	# Connect using the exact signal names from TitleScreen.gd
	title_screen.new_game.connect(_on_title_screen_new_game)
	title_screen.continue_game.connect(_on_title_screen_continue_game)
	title_screen.quit_game.connect(_on_title_screen_quit)


func _on_title_screen_new_game() -> void:
	SaveManager.clear_save()
	_start_game(false)


func _on_title_screen_continue_game() -> void:
	if SaveManager.has_save():
		_start_game(true)
	else:
		print("⚠️ No save found, starting new game instead.")
		_start_game(false)


func _on_title_screen_quit() -> void:
	get_tree().quit()


func _start_game(load_saved_data: bool) -> void:
	# Remove title screen
	if title_screen:
		title_screen.queue_free()
		title_screen = null

	# Instance and add game scene
	game_instance = game_scene.instantiate()
	add_child(game_instance)

	# Connect back to title
	game_instance.toTitle.connect(_load_title_screen)

	# Wait one frame so the scene tree is ready
	await get_tree().process_frame

	if load_saved_data:
		var data = SaveManager.load_player_data()
		game_instance.apply_player_data(data)
