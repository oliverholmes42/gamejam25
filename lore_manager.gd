extends CanvasLayer

@onready var display: RichTextLabel = $Display
@onready var timer: Timer = $Timer

var texts = {
	"first death": {
		"text": "Ah… another spark snuffed out. Yet here you are, still flickering.\nThe island feeds on death — but death feeds you in return.\nSpend wisely, little ember. The next life will burn brighter… or end quicker.",
		"duration": 10
	},
	"10-kills": {
		"text": "The island stirs. Your violence has a rhythm, and it listens.\nThe red coins hum softly — echoes of things that once breathed.",
		"duration": 6
	},
	"25-kills": {
		"text": "The blood remembers you now.\nEach kill pulls something ancient closer, drawn to your growing flame.",
		"duration": 6
	},
	"40-kills": {
		"text": "It moves beneath the roots, awake and hungry.\nYou’ve fed it well, little ember. Soon, it will reach for you.",
		"duration": 7
	},
	"50-kills": {
		"text": "The ground trembles… the dreamer opens its eye.\nThe feast begins.",
		"duration": 8
	},
	"endGame": {
		"text": "Silence. The island breathes its last, and the red fades to gray.\nYou have ended the cycle—or merely turned it anew?\nEven in victory, little ember, something still watches from above.\nThe End",
		"duration": 10
	}
}




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#display.hide()
	
	var stylebox = StyleBoxEmpty.new()
	stylebox.content_margin_left = 20
	stylebox.content_margin_top = 20
	stylebox.content_margin_right = 20
	stylebox.content_margin_bottom = 20
	
	display.add_theme_stylebox_override("normal", stylebox)
	
	render("endGame")
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func render(tag):
	var item = texts[tag]
	display.text = item.text
	display.show()
	timer.wait_time = item.duration
	timer.start()
	


func _on_timer_timeout() -> void:
	display.text = ""
	display.hide()
