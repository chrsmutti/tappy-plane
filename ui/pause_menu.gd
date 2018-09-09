extends Container

func _ready():
    add_to_group("pause_menu")
    connect("gui_input", self, "handle_input")

func hide():
	for child in get_children():
		child.visible = false
		if child.has_method("on_hide"):
			child.on_hide()

func handle_input(ev):
    if ev.is_action_pressed("tap") and GameState.get_state() == GameState.PAUSED:
        accept_event()
        unpause()

func unpause():
    hide()
    GameState.call_deferred("set_state", GameState.RUNNING)

func show_pause_menu():
    $Background.visible = true
    $Container.visible = true
    $Background.start_animation()