extends Button

func _ready():
	connect("pressed", self, "_on_button_pressed")

func _process(delta):
    if GameState.get_state() == GameState.RUNNING:
        self.visible = true
    else:
        self.visible = false

func _on_button_pressed():
    if GameState.get_state() != GameState.PAUSED:
        GameState.set_state(GameState.PAUSED)