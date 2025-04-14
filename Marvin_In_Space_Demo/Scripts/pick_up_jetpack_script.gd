#Should only be used once, when the character doesn't have its jetpack yet and we give it to it

extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.maxJumpCharges = 2
	character.updateJumpChargeSprite()
	character.removeInteractable($InteractionArea2D)
	queue_free()
