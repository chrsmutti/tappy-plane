extends Container

onready var score_label = find_node("Score")
onready var hi_score_label = find_node("Hi-Score")
onready var medal = find_node("Medal")
onready var button = find_node("Button")

func _ready():
	add_to_group("game_over")

func hide():
	for child in get_children():
		child.visible = false
		if child.has_method("on_hide"):
			child.on_hide()

func show_game_over(score, highest_score, record):
	button.set_disabled(false)
	for child in get_children():
		child.visible = true
		if child.has_method("start_animation"):
			child.start_animation()
	
	get_node("Tween").interpolate_method(self, "set_score", 0, score, 1, Tween.TRANS_EXPO, Tween.EASE_IN)
	get_node("Tween").interpolate_method(self, "set_highest_score", 0, highest_score, 1, Tween.TRANS_EXPO, Tween.EASE_IN)
	get_node("Tween").start()
	
	if record:
		find_node("NewHi-ScoreLabel").start_animation()
		
	if score > 15 and score >= (highest_score * 0.9):
		medal.visible = true
		medal.set_frame(1)
		medal.start_animation()
	elif score > 10 and score >= (highest_score * 0.8):
		medal.visible = true
		medal.set_frame(2)
		medal.start_animation()
	elif score > 5 and score >= (highest_score * 0.7):
		medal.visible = true
		medal.set_frame(0)
		medal.start_animation()

func set_score(value):
	score_label.set_text(str(floor(value)))
	
func set_highest_score(value):
	hi_score_label.set_text(str(floor(value)))

func hide_game_over():
	medal.visible = false
	$PanelContainer.visible = false
	$GameOver.visible = false
	$ButtonContainer.visible = false
	button.set_disabled(true)
	