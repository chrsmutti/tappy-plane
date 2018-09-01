extends Control

export(String, "audio", "sfx", "shake") var enable_type

var styles = ["hover", "pressed", "focus", "disabled", "normal"]
onready var texture_on = load(str("res://ui/", enable_type, "_on.png"))
onready var texture_off = load(str("res://ui/", enable_type, "_off.png"))

func _ready():
	set_mouse_filter(MOUSE_FILTER_STOP)
	connect("gui_input", self, "handle_input")
	_change_styles()

func handle_input(ev):
	if ev.is_action_pressed("tap") and GameState.get_state() == GameState.PAUSED:
		_on_button_pressed()
		get_tree().set_input_as_handled()

func _on_button_pressed():
	GameState.set(str(enable_type, "_enabled"), !GameState.get(str(enable_type, "_enabled")))
	_change_styles()

func _change_styles():
	for style in styles:
		if (GameState.get(str(enable_type, "_enabled"))):
			self.get(str("custom_styles/", style)).set_texture(texture_on)
		else:
			self.get(str("custom_styles/", style)).set_texture(texture_off)