extends Node2D

signal leaveUnderworld

@onready var exit_area: Area2D = $Exit
@onready var label: Label = $Exit/Label   # Add a Label as a child of ExitArea

var player_in_range: bool = false


func _ready() -> void:
	exit_area.body_entered.connect(_on_exit_area_entered)
	exit_area.body_exited.connect(_on_exit_area_exited)
	label.visible = false
	label.add_theme_font_size_override("font_size", 12)  # small readable text


func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		emit_signal("leaveUnderworld")


func _on_exit_area_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		label.visible = true
		label.text = "Interact to reincarnate"


func _on_exit_area_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		label.visible = false
