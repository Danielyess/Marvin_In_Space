extends StaticBody2D

func pickUp(player : CharacterBody2D) -> void:
	player.get_parent().collectibleGot = true
	player.removeInteractable($InteractionArea2D)
	queue_free()
