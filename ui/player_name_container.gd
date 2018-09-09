extends Container

func _ready():
    add_to_group("player_name")
    find_node("Name").set_text(GameState.current_player)

func hide():
    GameState.waiting_for_name = false
    for child in get_children():
        child.visible = false
        if child.has_method("on_hide"):
            child.on_hide()

func show():
    GameState.waiting_for_name = true
    $Background.visible = true
    $Container.visible = true
    $Background.start_animation()