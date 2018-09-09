extends HBoxContainer

func _ready():
	add_to_group("score")
	
func update_scores(current_score, highest_score, top_player):
	find_node("Score").set_text(str("Score: ", current_score))
	
	var hi_score_text
	if (top_player.length() > 0):
		if (top_player.length() > 10):
			top_player = str(top_player.substr(0, 7), '...')

		hi_score_text = str("Hi-Score: ", highest_score, " (", top_player, ")")
	else:
		hi_score_text = str("Hi-Score: ", highest_score)
	
	find_node("Hi-Score").set_text(hi_score_text)