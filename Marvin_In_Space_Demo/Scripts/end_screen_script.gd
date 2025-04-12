extends Control

var collectibleSpeed = 250
var direction = Vector2(1.0, 1.0)
var screenSize : Vector2
var collectibleGot : bool

func _ready() -> void:
	screenSize = get_viewport_rect().size
	collectibleGot = get_parent().collectibleGot
	if !collectibleGot:
		get_node("Collectible").queue_free()
	$VBoxContainer/MenuButton.grab_focus()

func _process(delta: float) -> void:
	if collectibleGot:
		var collectiblePos = get_node("Collectible").global_position
		
		get_node("Collectible").global_position += direction * collectibleSpeed * delta
		
		if (collectiblePos.y < 0 and direction.y < 0) or (collectiblePos.y > screenSize.y-(get_node("Collectible").size.y * get_node("Collectible").scale.y) and direction.y > 0):
			direction.y = -direction.y
		
		if (collectiblePos.x < 0 and direction.x < 0) or (collectiblePos.x > screenSize.x-(get_node("Collectible").size.x * get_node("Collectible").scale.x) and direction.x > 0):
			direction.x = -direction.x

func _on_collectible_pressed() -> void:
	print_debug("hihi refernce")

func _on_menu_button_pressed() -> void:
	get_parent().showMainMenu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
