extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_parent().initLevel(4)
	queue_free()
