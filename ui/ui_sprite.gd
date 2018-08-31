extends Object

func start_animation():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("ui_animation")

func on_hide():
	$AnimationPlayer.stop(true)