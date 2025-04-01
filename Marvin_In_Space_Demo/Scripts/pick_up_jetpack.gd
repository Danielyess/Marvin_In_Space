extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.maxJumpCharges = 2
	character.updateJumpChargeSprite()
	character.removeInteractable($Interact_Area2D)
	queue_free()
