extends Control

signal new_game
signal continue_game
signal quit_game


func _on_new_game_pressed() -> void:
	emit_signal("new_game")


func _on_continue_pressed() -> void:
	emit_signal("continue_game")


func _on_quit_pressed() -> void:
	emit_signal("quit_game")
