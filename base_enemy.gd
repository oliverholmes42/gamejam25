extends Area2D
class_name EnemyBase

@export var health: int = 10
var points = 10
signal givePoints

func take_damage(amount: int = 1) -> void:
	health -= amount
	print("%s took %d damage! Health now: %d" % [name, amount, health])
	if health <= 0:
		die()
		

func die() -> void:
	print("%s died." % name)
	emit_signal("givePoints", points)
	queue_free()
