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
var background_player
var waiting_for_name = false

var top_player = ""
var current_player = "Player"

var data = {}

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
	
	background_player = AudioStreamPlayer.new()
	add_child(background_player)
	background_player.set_stream(preload("res://world/background_music.ogg"))
	background_player.set_volume_db(-25)
	background_player.play()

	load_highest_score()
	highest_score = data['record']['value']

func _process(delta):
	if not audio_enabled and background_player.is_playing():
		background_player.stop()
	elif audio_enabled and not background_player.is_playing():
		background_player.play()

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
	get_tree().call_group("score", "update_scores", current_score, highest_score, top_player)

func update_environment_speed():
	environment_speed = max(min(environment_speed * 1.1, MAX_ENV_SPEED), MIN_ENV_SPEED)
	get_tree().call_group("environment", "update_speed", environment_speed)

func set_score(score):
	current_score = score
	if score > highest_score:
		top_player = "You"
		highest_score = score
		record = true
	call_update()
	
	if current_score % 5 == 0:
		update_environment_speed()
	
func reset():
	get_tree().reload_current_scene()
	call_deferred("start_screen")

func save_highest_score(name):
	current_player = name
	top_player = name
	
	data = {
		'current_player': current_player,
		'record': {
			'value': highest_score,
			'player': top_player
		}
	}

	var file = File.new()
	file.open("user://savedata.dat", file.WRITE)
	file.store_var(data)
	file.close()

func load_highest_score():
	var file = File.new()
	if (file.file_exists("user://savedata.dat")):
		file.open("user://savedata.dat", file.READ)
		data = file.get_var()

		current_player = data['current_player']
		highest_score = data['record']['value']
		top_player = data['record']['player']
	else:
		data = {
			'current_player': "Player",
			'record': {
				'value': 0,
				'player': ""
			}
		}