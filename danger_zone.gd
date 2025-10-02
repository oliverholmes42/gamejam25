extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func attack():
	var overlapping = get_overlapping_areas()
	for area in overlapping: 
		if area.is_in_group("enemy"):
			area.take_damage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
