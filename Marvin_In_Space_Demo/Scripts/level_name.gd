extends Control

func _process(_delta: float) -> void:
	$LevelLabel.position.x = get_viewport().get_camera_2d().position.x/2
	$LevelLabel.position.y = get_viewport().get_camera_2d().position.y/2

func setText(s : String) -> void:
	$LevelLabel.text = s 

func appear() -> void:
	$AnimationPlayer.play("LabelIn")
	$Timer.start()

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("LabelOut")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "LabelOut":
		queue_free()
