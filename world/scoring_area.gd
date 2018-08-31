extends Area2D

signal player_scored
var scored = false

func _ready():
	connect("body_entered", self, "on_body_entered")
	get_parent().set_texture(load(str("res://world/biomes/rock", GameState.current_biome, ".png")))
	
func on_body_entered(body):
	if body.get("TYPE") == "player" and not scored:
		emit_signal("player_scored")
		scored = true