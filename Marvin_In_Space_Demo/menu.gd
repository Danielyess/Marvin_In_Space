extends Control


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	get_parent().resume()


func _on_main_menu_button_pressed() -> void:
	get_parent().showMainMenu()


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
