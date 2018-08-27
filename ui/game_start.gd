extends MarginContainer

func _ready():
	add_to_group("game_start")

func hide():
	for child in get_children():
		child.visible = false
		if child.has_method("on_hide"):
			child.on_hide()

func show_game_start():
	$Tap.visible = true
	$Hand.visible = true
	$Hand.start_animation()
	
func show_timer():
	$GetReady.visible = true
	$Timer.visible = true
	$Tap.visible = false
	$Hand.visible = false
	$GetReady.start_animation()
	$Timer.start_animation()

func set_timer(time):
	$Timer.set_frame(time)