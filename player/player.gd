extends KinematicBody2D

const DOWN = Vector2(0, 1)
const MIN_FALL_SPEED = 10
const MAX_FALL_SPEED = 400
const TYPE = "player"

var score = 0
var speed = MIN_FALL_SPEED

func _physics_process(delta):
	match GameState.get_state():
		GameState.RUNNING:
			state_running(delta)
		GameState.GAME_OVER:
			if Input.is_action_just_pressed("reset"):
				GameState.reset()
		GameState.GAME_START:
			if $AnimationPlayer.current_animation != "running":
				$AnimationPlayer.play("running")
			if Input.is_action_just_pressed("tap"):
				GameState.start()
			

func state_running(delta):	
	if Input.is_action_just_pressed("tap"):
		speed = -(MAX_FALL_SPEED)
		SFX.play(preload("res://player/jump.ogg"))

	speed = min(speed + MIN_FALL_SPEED, MAX_FALL_SPEED)
	rotation_degrees = max(min(speed / MIN_FALL_SPEED, 45), -45)
	var collision = move_and_collide(DOWN * speed * delta)

	if collision != null:
		$AnimationPlayer.play("idle")
		GameState.set_state(GameState.GAME_OVER)
		
func on_player_scored():
	score += 1
	GameState.set_score(score)
