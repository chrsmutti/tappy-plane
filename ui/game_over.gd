extends MarginContainer

func _ready():
	add_to_group("game_over")
	find_node("NewHi-ScoreLabel").start_animation()

func hide():
	for child in get_children():
		child.visible = false
		if child.has_method("on_hide"):
			child.on_hide()