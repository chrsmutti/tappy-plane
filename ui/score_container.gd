extends HBoxContainer

func _ready():
	add_to_group("score")
	
func update_scores(current_score, highest_score):
	find_node("Score").set_text(str("Score: ", current_score))
	find_node("Hi-Score").set_text(str("Hi-Score: ", highest_score))