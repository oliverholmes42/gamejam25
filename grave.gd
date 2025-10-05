extends Area2D

@export_enum("health", "attack", "speed") var upgrade_type: String
@export var upgrade_amount: int = 10
@export var cost: int = 50

@onready var label: Label = $Label

signal upgrade_bought(upgrade_type: String, amount: int, cost: int)

var player_in_range: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.visible = false

	label.add_theme_font_size_override("font_size", 10)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		label.visible = true
		label.text = "Interact to upgrade %s\nCost: %d gold" % [upgrade_type, cost]

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		label.visible = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("stuff")
		var player = get_tree().get_first_node_in_group("player")
		if player and player.spend_gold(cost):
			player.upgrade(upgrade_type, upgrade_amount)
