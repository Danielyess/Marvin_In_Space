extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.canDash = 1
	character.updateDashSprite()
	character.removeInteractable($Interact_Area2D)
	queue_free()
