extends Area2D
var attack = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_attack():
	var inRange = get_overlapping_areas()
	print(inRange)
	for area in inRange:
		print(area)
		if(area.is_in_group("enemy")):
			area.take_damage(attack)
