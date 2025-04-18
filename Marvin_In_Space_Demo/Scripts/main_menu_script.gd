extends Control

func _ready() -> void:
	$VBoxContainer/PlayButton.grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
<<<<<<< Updated upstream
	get_parent().initLevel(5)
=======
	get_parent().initLevel(10)
>>>>>>> Stashed changes
