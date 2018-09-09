extends Button

onready var name_edit = get_parent().get_node("Name")
onready var player_name_container = get_parent().get_parent()

func _ready():
    connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
    var name = name_edit.get_text()
    if (name.length() == 0):
        name = "Player"
    GameState.save_highest_score(name)
    player_name_container.get_parent().get_node("GameOver").show_children()
    player_name_container.hide()