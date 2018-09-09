extends Control

export(String, "audio", "sfx", "shake") var enable_type

export (Color) var enabled = Color("#fff")
export (Color) var disabled = Color("#323232")

func _ready():
	set_mouse_filter(MOUSE_FILTER_STOP)
	connect("gui_input", self, "handle_input")
	_change_styles()

func handle_input(ev):
	if ev.is_action_pressed("tap"):
		_on_button_pressed()
		get_tree().set_input_as_handled()

func _on_button_pressed():
	GameState.set(str(enable_type, "_enabled"), !GameState.get(str(enable_type, "_enabled")))
	_change_styles()

func _change_styles():
	if (GameState.get(str(enable_type, "_enabled"))):
		get_node("Status/Container/On").set_modulate(enabled)
		get_node("Status/Container/Off").set_modulate(disabled)
	else:
		get_node("Status/Container/Off").set_modulate(enabled)
		get_node("Status/Container/On").set_modulate(disabled)