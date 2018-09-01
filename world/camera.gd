extends Camera2D

var shake_amount = 5
var shaking = false
	
func shake(timeout=5, shake_amount=5):
	if GameState.shake_enabled:
		shaking = true
		shake_amount = shake_amount
		var timer = Timer.new()
		timer.wait_time = timeout
		add_child(timer)
		timer.connect("timeout", self, "stop_shaking")
		timer.start()

func stop_shaking():
	shaking = false

func _process(delta):
	if shaking:
		set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))
	else:
		set_offset(Vector2(0, 0))