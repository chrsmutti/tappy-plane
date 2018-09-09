extends Sprite

var speed = 200
var x_offset = 0

export(Color) var night_color
var night = false

func _ready():
	add_to_group("environment")
	if GameState.current_biome == GameState.BIOME_ICE and not night:
		night = true
		modulate = night_color

func update_speed(new_speed):
	speed = new_speed

func _process(delta):
	if GameState.current_biome == GameState.BIOME_ICE and not night:
		$Tween.interpolate_property(self, "modulate", modulate, night_color, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		night = true
	if GameState.current_biome != GameState.BIOME_ICE and night:
		night = false
		$Tween.interpolate_property(self, "modulate", modulate, Color("#fff"), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()

	if GameState.get_state() == GameState.RUNNING:
		x_offset += speed * delta
		
		if is_region():
			set_region_rect(Rect2(Vector2(x_offset, 0), get_region_rect().size))