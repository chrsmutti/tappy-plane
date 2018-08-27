extends Object

func start_animation():
	$AnimationPlayer.play("ui_animation")

func on_hide():
	$AnimationPlayer.stop(true)