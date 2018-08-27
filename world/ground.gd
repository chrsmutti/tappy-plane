extends RigidBody2D

const TYPE = "ground"
var speed = 200
var direction = Vector2(-1, 0)
	
func _ready():
	add_to_group("environment")

func update_speed(new_speed):
	speed = new_speed

func _process(delta):
	if GameState.get_state() == GameState.RUNNING:
		self.global_translate(Vector2(speed * delta, 0) * direction)