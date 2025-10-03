extends CanvasLayer
var health
var points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = $ProgressBar
	points = $Points
	points.add_theme_font_size_override("normal_font_size", 32)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func applyHealth(newValue):
	health.value = newValue
	
func applyPoints(nPoints):
	points.text = str(nPoints)
