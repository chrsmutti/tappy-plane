extends Node

const GAME_START = "game_start"
const RUNNING = "running"
const GAME_OVER = "game_over"
const PAUSED = "paused"

const BIOME_NONE = ""
const BIOME_GRASS = "Grass"
const BIOME_ICE = "Ice"
const BIOME_SNOW = "Snow"

const MAX_ENV_SPEED = 400
const MIN_ENV_SPEED = 250

var current_state = GAME_START
var current_score = 0
var highest_score = 0
var environment_speed = MIN_ENV_SPEED
var starting = false
var record = false
var start_time = 0
var current_biome = BIOME_NONE
var timer

var sfx_enabled = true
var audio_enabled = true
var shake_enabled = true

signal highest_score_changed
signal score_changed

func _ready():
	call_deferred("start_screen")
	
	timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "countdown")
	
	var biome_timer = Timer.new()
	biome_timer.wait_time = 30
	add_child(biome_timer)
	biome_timer.connect("timeout", self, "change_biome")
	biome_timer.start()
	change_biome()
	
	var background_player = AudioStreamPlayer.new()
	add_child(background_player)
	background_player.set_stream(preload("res://world/background_music.ogg"))
	background_player.set_volume_db(-25)
	background_player.play()
	
	highest_score = int(load_highest_score())

func change_biome():
	randomize()
	match (randi() % 4):
		0:
			current_biome = BIOME_NONE
		1:
			current_biome = BIOME_GRASS
		2:
			current_biome = BIOME_ICE
		3:
			current_biome = BIOME_SNOW

func unpause():
	get_tree().call_group("pause_menu", "unpause")

func set_state(state):
	current_state = state
	if state == GameState.GAME_OVER:
		get_tree().call_group("game_over", "show_game_over", current_score, highest_score, record)
		save_highest_score(highest_score)
	if state == GameState.PAUSED:
		get_tree().call_group("pause_menu", "show_pause_menu")
	
func start():
	if not starting:
		get_tree().call_group("game_start", "show_timer")
		start_time = 3
		timer.start()
		get_tree().call_group("game_start", "set_timer", start_time)
		starting = true

func countdown():
	start_time -= 1
	if start_time <= 0:
		set_state(GameState.RUNNING)
		starting = false
		timer.stop()
		get_tree().call_group("game_start", "hide")
		SFX.play(preload("res://ui/start.ogg"))
	else:
		get_tree().call_group("game_start", "set_timer", start_time)
		SFX.play(preload("res://ui/count.ogg"))

func get_state():
	return current_state

func start_screen():
	record = false
	current_score = 0
	environment_speed = 0
	GameState.set_state(GameState.GAME_START)
	call_update()
	update_environment_speed()
	get_tree().call_group("game_start", "show_game_start")

func call_update():
	get_tree().call_group("score", "update_scores", current_score, highest_score)

func update_environment_speed():
	environment_speed = max(min(environment_speed * 1.1, MAX_ENV_SPEED), MIN_ENV_SPEED)
	get_tree().call_group("environment", "update_speed", environment_speed)

func set_score(score):
	current_score = score
	if score > highest_score:
		highest_score = score
		record = true
	call_update()
	
	if current_score % 5 == 0:
		update_environment_speed()
	
func reset():
	get_tree().reload_current_scene()
	call_deferred("start_screen")
	
func save_highest_score(content):
	var file = File.new()
	file.open("user://highest_score.dat", file.WRITE)
	file.store_string(str(content))
	file.close()

func load_highest_score():
	var file = File.new()
	if (file.file_exists("user://highest_score.dat")):
		file.open("user://highest_score.dat", file.READ)
		var content = file.get_as_text()
		file.close()
		return content
	else:
		return "0"