extends StaticBody2D

func pickUp(player : CharacterBody2D) -> void:
	player.get_parent().collectibleGot = true
	player.removeInteractable($Interaction_Area2D)
	queue_free()
