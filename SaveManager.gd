extends Node

const SAVE_PATH := "user://player_save.json"

# Save relevant player stats
func save_player_data(player):
	var data = {
		"max_health": player.max_health,
		"speed": player.speed,
		"attack": player.swordSwing.attack,
		"score": player.score,
		"deaths": player.deaths
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("✅ Saved player data:", data)

# Load saved data
func load_player_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		print("⚠️ No save file found.")
		return {}
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		print("✅ Loaded player data:", data)
		return data
	else:
		push_warning("❌ Failed to parse save data.")
		return {}

# Check if a save exists
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# Delete save data for a brand new game
func clear_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
		print("🗑️ Cleared old save file.")
