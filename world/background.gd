extends Sprite

var speed = 200
var x_offset = 0

func _ready():
	add_to_group("environment")

func update_speed(new_speed):
	speed = new_speed

func _process(delta):
	if GameState.get_state() == GameState.RUNNING:
		x_offset += speed * delta
		
		if is_region():
			set_region_rect(Rect2(Vector2(x_offset, 0), get_region_rect().size))