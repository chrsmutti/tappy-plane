extends Area2D


func _ready():
	connect("body_entered", self, "spawn_ground")
	connect("body_exited", self, "destroy_ground")
	
func destroy_ground(body):
	if body.get("TYPE") == "ground":
		body.queue_free()
		
func spawn_ground(body):
	if body.get("TYPE") == "ground":
		var ground_instance = preload("res://world/biomes/ground.tscn").instance()
		ground_instance.set_position(body.get_position() + Vector2(808, 0))
		ground_instance.set_rotation(body.get_rotation())
		ground_instance.speed = body.speed
		get_parent().add_child(ground_instance)
		spawn_rocks(ground_instance)
		
func spawn_rocks(ground_instance):
	randomize()
	var rocks_node = ground_instance.find_node("Rocks")
	var rocks = rocks_node.get_children()
	if len(rocks) > 0:
		var rocks_count = floor(len(rocks) / 2)
		var already_set = [0]
		for rock in range(rocks_count):
			var position = 0
			while already_set.has(position):
				position = randi() % len(rocks) + 1
			
			already_set.append(position)
			var position_node = rocks_node.find_node(str("Position", position))
			var rock_instance = preload("res://world/biomes/rock.tscn").instance()
			position_node.add_child(rock_instance)
			
			var player = get_parent().get_parent().find_node("Player")
			rock_instance.find_node("ScoringArea").connect("player_scored", player, "on_player_scored")